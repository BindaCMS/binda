module Binda
	# Some fields are meant to be unique, meaning there must be only one instance 
	# 	associated with a specific component and field setting
	module FieldUniqueness	
		
		extend ActiveSupport::Concern

		included do
			validate  :field_uniqueness
		end
		# Make sure there is only one instance associated simultaneously with a specific component and field setting
		# @return [boolean]
		def field_uniqueness
			instances = Text.where(
				field_setting_id: self.field_setting.id,
				fieldable_id: self.fieldable_id,
				fieldable_type: self.fieldable_type
			)
			if instances.any? && instances.first.id != self.id
				errors.add(:base, I18n.t("binda.duplicate_validation", { 
					arg1: self.field_setting.field_type, 
					arg2: self.fieldable_id,
					arg3: self.field_setting.slug 
				}))
				return false
			else
				return true
			end
		end
	end
end