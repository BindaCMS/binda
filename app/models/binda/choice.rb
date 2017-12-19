module Binda
  class Choice < ApplicationRecord

  	belongs_to :field_setting
  	has_and_belongs_to_many :selections

		validates :label, presence: true
		validates :value, presence: true
		validates :field_setting_id, presence: true

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
		def reset_default_choice

			# Make sure you are referring to the updated ActiveRecord object where the choice has already been deleted
			#	Infact: self.field_setting != FieldSetting.find( self.field_setting.id )
			field_setting = FieldSetting.find(self.field_setting.id)

			# Don't do anything if the default choice isn't the one we just destroyed
			return if field_setting.choice_ids.include? field_setting.default_choice_id
			
			# Make sure the default choice is needed
			return if field_setting.allow_null? && field_setting.field_type != 'radio'


			if field_setting.choices.any?
				# Mark as default choice the first choice available
				field_setting.default_choice_id = field_setting.choices.first.id
			else
				# Remove default choice setting (which at this point is the current choice (self))
				field_setting.default_choice_id = nil
			end

			# Save and check if it's alright
			unless field_setting.save
				raise "It hasn't been possible to set the default choice for the current setting (#{field_setting.slug})."
			end

			# Create an empty array in order to avoid generating an error on the following each loop
			selections = Selection.joins(:field_setting).where(binda_field_settings: {id: field_setting.id })

			# Make sure none of the Binda::Selection instances (radios/checkboxes/selects) are left without a choice
			selections.each do |selection|
				unless selection.choices.any?
					selection.choices << Choice.find(self.field_setting.default_choice_id)
					unless selection.save
						raise "It hasn't been possible to set the default choice for Binda::Selection with id=#{selection.id}"
					end
				end
			end
		end

  end
end
