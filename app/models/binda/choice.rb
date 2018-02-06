module Binda
	# Choices are used in **select**, **radio** and **checkboxes** and defined by a **field setting**. 
	#
	# The architecture of this class is a bit complex and deserves some attention:
	#   Here the rules that defines the class behaviour:
	# 
	# 1. **Choices** must be associated to a **field setting**
	# 2. Every **choice** can be associated to several **select/radio/checkbox**
	# 3. (This is tricky) Assuming you are going to delete a choice and 1) **field setting** requires at least one choice
	#   2) some **select/checkbox/radio** are associated just to that **choice**. To be able to do it you must first replace 
	#   that **choice** on those **select/checkbox/radio**. Only then you can delete that **choice**.
	#   
	# The **default choice** is applied only to field that requires at least a **choice**.
  class Choice < ApplicationRecord

  	belongs_to :field_setting
  	has_and_belongs_to_many :selections

		validates :label, presence: {
			message: I18n.t('binda.choice.label_validation_message')
		}
		validates :value, presence: {
			message: I18n.t('binda.choice.value_validation_message')
		}
		validates :field_setting_id, presence: {
			message: I18n.t('binda.choice.field_setting_id_validation_message')
		}

		before_destroy :check_last_choice
		after_create :set_default_choice
		after_destroy :reset_default_choice

		# Some field setting requires at least one choice. To avoid leaving this kind of field setting without
		#   any choice, a validation checks that there is at least an alternative choice that will become the default one.
		# This validation is skipped when deleting the field setting from which the choice depends because choice are 
		#   deleted directly from database (see `dependent: :delete_all`).
		def check_last_choice
			if !self.field_setting.allow_null? && Choice.where(field_setting_id: self.field_setting.id).length == 1
				errors.add(:base, I18n.t('binda.choice.validation_message.destroy'))
				throw(:abort)
			end
		end

		# In order to make sure that a default choice is set, this method is executed after
		#   the first choice is associated to the field setting. What does it do? 
		#   If there isn't a default it sets the current choice as the default one.
		#   The method is executed as well if new choices are added.
		def set_default_choice
			# Make sure you are referring to the updated ActiveRecord object where the choice has already been deleted
			#	Infact: self.field_setting != FieldSetting.find( self.field_setting.id )
			field_setting = FieldSetting.find(self.field_setting.id)
			if field_setting.default_choice_id.nil? && !field_setting.allow_null?
				# if field_setting.field_type = 'radio' 
				field_setting.default_choice_id = self.id
				unless field_setting.save
					raise "It hasn't been possible to set the default choice for the current setting (#{field_setting.slug})."
				end
				assign_choice_to_selections(field_setting, self)
			end
		end

		# Assign a choice to `Binda::Selection` items belonging to a specific field setting.
		# 
		# TODO it shouldn't be possible to add another choice to a radio button. 
		#   The only reasonable way is to change has_many association in a has_one
		# 
		# @param field_setting [Binda::FieldSetting]
		# @param new_default_choice [Binda::Choice]
		def assign_choice_to_selections(field_setting, new_default_choice)
			Selection.where(field_setting_id: field_setting.id).each do |selection|
				selection.choices << new_default_choice
				unless selection.save
					raise "It hasn't been possible to set the default choice for #{selection.class.name} with id=#{selection.id}."
				end
			end
		end

		# In order to make sure a default choice is set, this method is executed after the 
		#   default choice is removed. What does it do? If the removed choice is the default one it sets
		#   another defautl picking the first of the choices associated by id. 
		#   Once done, update all associated records that now don't have the any associated choice.
		#   
		# This method doesn't run when a field setting is destroyed as the association is
		#   `Binda::FieldSetting has_many :choices, dependent: :delete_all` not `dependent: :destory`. 
		#   That means the `after_destroy` callback for Binda::Choice (and this method as well) won't run.
		def reset_default_choice
			# Make sure you are referring to the updated ActiveRecord object where the choice has already been deleted
			#	Infact: self.field_setting != FieldSetting.find(self.field_setting.id)
			field_setting = FieldSetting.find(self.field_setting.id)

			# Don't do anything if the default choice isn't the one we just destroyed
			return if field_setting.choice_ids.include?(field_setting.default_choice_id)
			
			# Make sure the default choice is needed
			return if field_setting.allow_null? && field_setting.field_type != 'radio'

			if field_setting.choices.any?
				# Mark as default choice the first choice available
				update_default_choice(field_setting, field_setting.choices.first.id)
			else
				warn("WARNING: Binda::FieldSetting \"#{field_setting.slug}\" doesn't have any default choice! Please set a new default choice and then run the following command from Rails Console to update all related Binda::Selection records: \nrails binda:add_default_choice_to_all_selections_with_no_choices")
				# Remove default choice setting (which at this point is the current choice (self))
				update_default_choice(field_setting, nil)
			end

			# Update all selection records which depend on the deleted choice
			Selection.check_all_selections_depending_on(field_setting)
		end

		private 

			# Update field setting with a default choice
			# 
			# This is private method for reset_default_choice method.
			# 
			# @param field_setting [ActiveRecord Object]
			def update_default_choice(field_setting, id)
				# Update and check if it's alright
				unless field_setting.update(default_choice_id: id) 
					raise "It hasn't been possible to set the default choice for the current setting (#{field_setting.slug})." 
				end
			end

  end
end
