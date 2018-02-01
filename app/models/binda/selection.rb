module Binda
	# `Binda::Selection` class provides support for **selection**, **radio** and **checkbox** fields.
	# 
	# More specifically `Binda::Selection` is used for **selection** fields, whereas **radio** and 
	#   **checkbox** fields depend on `Binda::Radio` and `Binda::Checkbox` which are subclasses of `Binda::Selection`.
	#   
	# The architecture behind this class is pretty complex and deserves some attention. 
	#   Here the rules that defines the class behaviour:
	#   
	# 1. Every selection can have multiple **choices** (see `Binda::Choice`) or none.
	# 
	# 2. Every **selection** depends on a **field setting** (see `Binda::FieldSetting` 
	#   [documentation](http://www.rubydoc.info/gems/binda/Binda/FieldSetting)) which specify its behaviour.
	# 
	# 3. Every time you create a **field setting** a fallback ensure a **selection** exists for every 
	#   **component** or **board** to which this **field setting** belongs. This ensure calling `get_selection_choices`
	#   method doesn't throw a error.
	#   ```ruby
	#   # Create a field setting for a component
	#   component = Binda::Component.first
	#   field_setting = component.structure.field_groups.first.field_settings.create(
	#       name: 'my selection',
	#       field_type: 'selection'
	#   )
	#   # Reload component so the Active Record object is updated
	#   component.reload
	#   # We know for sure a selection exists
	#   component.selections.any?
	#   # => true
	#   # We might not find any choice though
	#   component.get_selection_choices(field_setting.slug)
	#   # => []
	#   ```
	#   
	# 4. When a **field setting** is created there is no **choice** available yet. Only if a **setting** requires 
	#   at least a **choice**, a new **choice** is created. In that case the **choice** is also automatically set as 
	#   the **default choice** for the **field setting** and applied to all **selections** that didn't have any **choice**. 
	#   Again, this behaviour exists just for **field settings** that requires at least a **choice** and has just 
	#   been created. Changing the **field setting** **default choice** persisted on the database with another one 
	#   won't change the **selected choice** of any **selections** created before: they will keep the previous 
	#   **default choice**. For more info look at `Binda::Choice` 
	#   [documentation](http://www.rubydoc.info/gems/binda/Binda/Choice)
	#   ```ruby
	#   # Create a field setting for a component (note: allow_null is set to false)
	#   component = Binda::Component.first
	#   field_setting = component.structure.field_groups.first.field_settings.create(
	#       name: 'my selection',
	#       field_type: 'selection', 
	#       allow_null: false # IMPORTANT: this means field setting requires at least a choice
	#   )
	#   # If field setting doesn't allow null, it means we always expect a choice to be selected
	#   component.get_selection_choices(field_setting.slug)
	#   # A default choice is returned
	#   # => [{ label: 'Temporary choice', value: 'temporary-choice' }]
	#   component.get_selection_choices(field_setting.slug)
	#   # => [{ label: 'Temporary choice', value: 'temporary-choice' }]
	#   # When we remove the initial choice we fallback to default
	#   field_setting.choices.first.delete
	#   # => error!
	#   field_setting.choices.create(
	#       label: 'second', 
	#       value: 'second'
	#   )
	#   field_setting.choices.first.destroy
	#   component.get_selection_choices(field_setting.slug)
	#   # => [{ label: 'second', value: 'second' }]
	#   ```
	# 
	# 5. Every time a **field setting** is updated a fallback ensures all **selections** relying on it are updated as well.
	#   ```ruby
	#   # Create a field setting for a component
	#   component = Binda::Component.first
	#   field_setting = component.structure.field_groups.first.field_settings.create(
	#       name: 'my selection',
	#       field_type: 'selection', 
	#       allow_null: false
	#   )
	#   field_setting.choices.create([
	#       {
	#           label: 'first', 
	#           value: 'first'
	#       },
	#       {
	#           label: 'second', 
	#           value: 'second'
	#       },
	#   ])
	#   # field_setting automatically assigns **first choice** as default and replace the **temporary default choice**.
	#   # Now reload component to update it with the instances just created
	#   component.reload
	#   component.selections.first.choices << field_setting.choices.first
	#   component.selections.first.choices << field_setting.choices.last
	#   component.get_selection_choices(field_setting.slug)
	#   # => [{ label: 'first', value: 'first' }, { label: 'second', value: 'second' }]
	#   # Remove the initial choice
	#   field_setting.choices.first.delete
	#   # Get selection choices again. Now you should get a different result
	#   component.reload.get_selection_choices(field_setting.slug)
	#   # => [{ label: 'second', value: 'second' }]
	#   ```
	# 
	# 6. (This is the trickiest) 
	#   Assuming that 
	#   1) **field setting** requires at least a **choice**, 
	#   2) there is only one **choice** available, 
	#   3) some **selections** are associated to that **choice**. 
	#   If the user replace that **choice** with another one, all **selections** fields will be associated to 
	#   the new one.
	#   ```ruby
	#   # Create a field setting for a component
	#   component = Binda::Component.first
	#   field_setting = component.structure.field_groups.first.field_settings.create(
	#       name: 'my selection',
	#       field_type: 'selection', 
	#       allow_null: false
	#   )
	#   # Trying to delete the default temporary choice, which is the only one, won't work
	#   field_setting.choices.first.destroy
	#   # => false
	#   # You need to create another choice first
	#   field_setting.choices.create(
	#       label: 'Second', 
	#       value: 'second'
	#   )
	#   field_setting.choices.first.destroy
	#   component.reload.get_selection_choices(field_setting.slug)
	#   # => [{ label: 'second', value: 'second' }]
	#   # BE AWARE THAT:
	#   field_setting.choices.delete_all
	#   # => deletes everything skipping callbacks and will cause inconsistency throughout the database
	#   ```
	# 
	class Selection < ApplicationRecord

		has_and_belongs_to_many :choices
		belongs_to :field_setting

		validate :has_choices
		validates :fieldable_id, presence: true

		after_save do
			if !self.field_setting.allow_null && 
				!self.field_setting.default_choice_id.nil? &&
				!self.choices.any?
				assign_default_choice
			end
		end

		# Fix selections which have no choice even though the field setting requires at least one
		#
		# This method gets all `Binda::Selection` records that depend on a field setting which 
		#   requires that the selection has at least one choice and which haven't any choice selected. 
		#   This method is used on the user interface and a rake task.
		# 
		# Raise an error if the related field setting doesn't have any choice or the default choice isn't selected
		def self.add_default_choice_to_all_selections_with_no_choices(field_setting = nil)
			# Get all Binda::Selection records that:
			# - depend on a field setting which requires to have at least a choice
			# - have no choice selected

			selections = Selection.get_selections_which_must_have_a_choice_but_have_none(field_setting)
			selections.each do |selection|
				unless selection.field_setting.default_choice_id.nil?
					selection.assign_default_choice
				else
					raise "Binda::Selection with id=\"#{selection.id}\" cannot be fixed because its field setting doesn't have any available choice. Please add at least a choice to field setting \"#{selection.field_setting.slug}\"."
				end
			end
		end

		# Assign default choice to a selection
		def assign_default_choice
			self.choices << self.field_setting.default_choice
		end

		# Check all Binda::Selection records which are required to have a choice.
		# 
		# The purpose of this method is to check, not to update. You don't won't to decide which choice 
		#   must be selected if the selection is required to have one. You just want the user to know that
		#   it's not possible to leave it without any.
		# 
		# @param field_setting [ActiveRecord Object]
		def self.check_all_selections_depending_on(field_setting)
			# Make sure Active Record object of field setting is updated
			field_setting.reload

			# Don't bother if field setting allow having no choice or if default_choice isn't set
			return if field_setting.allow_null? || field_setting.default_choice_id.nil?

			# Get all selection related to this field setting which have an issue with choices
			selections = Selection.get_selections_which_must_have_a_choice_but_have_none(field_setting)

			# Warn the user that there's a problem
			selections.each do |selection|
				selection.choices << field_setting.default_choice
				unless selection.save
					raise "It hasn't been possible to assign Binda::Choice with id=\"#{field_setting.default_choice_id}\" to Binda::Selection with id=\"#{self.id}\"."
				end
			end
		end

		# Get selections which must have a choice, but have none
		# 
		# Get all Binda::Selection records that:
		# - depend on a field setting which requires to have at least a choice
		# - have no choice selected
		# 
		# @param field_setting_slug [string] Add the slug of a field setting to filter the query
		# 
		# @return [array] An array of Binda::Selection objects
		def self.get_selections_which_must_have_a_choice_but_have_none(field_setting = nil)
			if field_setting.nil?
				Selection.includes(:choices, :field_setting)
					.where(
						binda_choices_selections: { selection_id: nil },
						binda_field_settings: { allow_null: false }
					)
			elsif field_setting_id == FieldSetting.get_id(field_setting.slug)
				Selection.includes(:choices, :field_setting)
					.where(
						binda_choices_selections: { selection_id: nil }, 
						binda_selections: { field_setting_id: field_setting_id },
						binda_field_settings: { allow_null: false }
					)
			end
		end

		# Get selection
		def has_choices
			field_setting = self.field_setting
			case 
			when self.new_record?
				return true
			when !field_setting.allow_null? && field_setting.choices.any? && self.choices.empty?
				errors.add(:base, I18n.t("binda.selection.validation_message.choices", { arg1: self.id, arg2: field_setting.slug })
				)
				return false
			else
				return true
			end
		end

	end
end