module Binda
	module FieldableAssociationHelpers
		module FieldableStringHelpers
			
			# Get the object related to that field setting
			# If the object doesn't exists yet it will return nil
			# 
			# @param  field_slug [string] The slug of the field setting
			# @return [string] Returns the content of the string 
			# @return [error]  Raise an error if no record is found
			def get_string(field_slug)
				obj = Text
					.includes(:field_setting)
					.where(fieldable_id: self.id, fieldable_type: self.class.name)
					.where(binda_field_settings: { slug: field_slug, field_type: "string" })
					.first
				unless obj.nil?
					# to_s ensures the returned object is class String
					obj.content.to_s
				else
					check_string_error field_slug
				end
			end

			# Check why get_string doesn't return a value
			# This method isn't supposed to be used by anything other than get_string method
			def check_string_error(field_slug)
				you_mean_text = !self.strings.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) && t.type == 'Binda::Text' }.nil?
				if you_mean_text
					raise ArgumentError, "This slug (#{field_slug}) is associated to a text not a string. Use get_text() instead on instance (#{self.class.name} ##{self.id}).", caller
				else
					raise ArgumentError, "There isn't any string associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller
				end
			end

			# Get the object related to that field setting
			# 
			# @param field_slug [string] The slug of the field setting
			# @return [boolean]
			def has_string(field_slug)
				obj = Text
					.includes(:field_setting)
					.where(fieldable_id: self.id, fieldable_type: self.class.name)
					.where(binda_field_settings: { slug: field_slug, field_type: "string" })
					.first
				raise ArgumentError, "There isn't any string associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
				if obj.present?
					return !obj.content.nil?
				else
					return false
				end
			end
			
		end
	end
end