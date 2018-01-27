module Binda
	class Selection < ApplicationRecord

		has_and_belongs_to_many :choices
		belongs_to :field_setting

		# Fix selections which have no choice even though the field setting requires at least one
		#
		# This method gets all `Binda::Selection` records that depend on a field setting which 
		#   requires that the selection has at least one choice and which haven't any choice selected. 
		#   This method is used on the user interface and a rake task.
		# 
		# Raise an error if the related field setting doesn't have any choice or the default choice isn't selected
		def self.add_default_choice_to_all_selections_with_no_choices			
			# Get all Binda::Selection records that:
			# - depend on a field setting which requires to have at least a choice
			# - have no choice selected
			selections = Selection.get_selections_which_must_have_a_choice_but_have_none
			selections.each do |selection|
				unless selection.field_setting.default_choice_id.nil?
					selection.fix_selection_default_choice
				else
					raise "Binda::Selection with id=\"#{selection.id}\" cannot be fixed because its field setting doesn't have any available choice. Please add at least a choice to field setting \"selection.field_setting.slug\" before trying to fix this record."
				end
			end
		end

		# Fix selection (which is required to have at least a choice) by adding a choice
		# 
		# This method is used by fix_selections method. It cannot be private and must be a class method in order to be used by rake task.
		def fix_selection_default_choice
			self.choices << self.field_setting.choices.select{|c| c.id == self.field_setting.default_choice_id }
			if self.save
				puts "Binda::Selection with id=\"#{self.id}\" has been fixed"
			else
				raise "Binda::Selection with id=\"#{self.id}\" cannot be fixed. Something is wrong with existing choices either on the selection record or the relative field setting (#{self.field_setting.slug})"
			end
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

			# Don't bother if field setting allow having no choice 
			return if field_setting.allow_null?

			# Get all selection related to this field setting which have an issue with choices
			selections = Selection.get_selections_which_must_have_a_choice_but_have_none

			# Warn the user that there's a problem
			selections.each do |selection|
				warn("WARNING: Binda::Selection with id=\"#{selection.id}\" doesn't have any choice selected, but it's required to have one.\n") 
			end

			# Send to user a possible solution to update selections in batch
			if selections.any?
				warn("Use the following command from Rails console to assign the default choice to all selections with the same issue. \nrails binda:add_default_choice_to_all_selections_with_no_choices\n")
			end
		end

		# Get selections which must have a choice, but have none
		# 
		# Get all Binda::Selection records that:
		# - depend on a field setting which requires to have at least a choice
		# - have no choice selected
		def self.get_selections_which_must_have_a_choice_but_have_none
			Selection.left_outer_joins(:choices)
				.where(
					binda_choices_selections: { selection_id: nil }, 
					binda_selections: { field_setting_id: FieldSetting.where(allow_null: false).ids })
				.includes(field_setting: [:choices])
		end
	end
end