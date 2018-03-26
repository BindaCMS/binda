module Binda
	module FieldableAssociationHelpers
		module FieldableDateHelpers
			# Check if the field has an attached date
			# 
			# @param field_slug [string] The slug of the field setting
			# @return [datetime] The date
			# @return [boolean] Reutrn false if nothing is found
			def has_date(field_slug)
				obj = self.dates.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
				raise ArgumentError, "There isn't any date associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
				if obj.present?
					return !obj.date.nil?
				else
					return false
				end
			end

			# Get the object related to that field setting
			# 
			# @param field_slug [string] The slug of the field setting
			# @return [boolean]
			def get_date(field_slug)
				obj = self.dates.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
				raise ArgumentError, "There isn't any date associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
				obj.date
			end
		end
	end
end