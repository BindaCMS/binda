module Binda
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

		after_create :set_default_choice
		after_destroy :reset_default_choice

		# In order to make sure that a default choice is set, this method is executed after
		#   the first choice is associated to the field setting. What does it do? 
		#   If there isn't a default it sets the current choice as the default one.
		#   The method is executed as well if new choices are added.
		def set_default_choice
			
			# Make sure you are referring to the updated ActiveRecord object where the choice has already been deleted
			#	Infact: self.field_setting != FieldSetting.find( self.field_setting.id )
			field_setting = FieldSetting.find(self.field_setting.id)
			
			# unless Choice.find(field_setting.default_choice_id).present?
			return unless field_setting.default_choice_id.nil?
			field_setting.default_choice_id = self.id
			unless field_setting.save
				raise "It hasn't been possible to set the default choice for the current setting (#{field_setting.slug})."
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
			return if field_setting.choice_ids.include? field_setting.default_choice_id
			
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
