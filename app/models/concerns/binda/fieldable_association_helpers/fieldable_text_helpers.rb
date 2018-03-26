module Binda
	module FieldableAssociationHelpers
		module FieldableTextHelpers

			extend ActiveSupport::Concern
			# Get the object related to that field setting
			# If the object doesn't exists yet it will return nil
			# 
			# @param  field_slug [string] The slug of the field setting
			# @return [string] Returns the content of the text 
			# @return [error]  Raise an error if no record is found
			def get_text(field_slug)
				obj = Text
					.includes(:field_setting)
					.where(fieldable_id: self.id, fieldable_type: self.class.name)
					.where(binda_field_settings: { slug: field_slug })
					.where.not(binda_field_settings: { field_type: "string" })
					.first
				unless obj.nil?
					# to_s ensures the returned object is class String
					obj.content.to_s
				else
					check_text_error field_slug
				end
			end

			# Check why get_text doesn't return a value
			# This method isn't supposed to be used by anything other than get_text method
			def check_text_error(field_slug)
				you_mean_string = !self.strings.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) && t.type == 'Binda::String' }.nil?
				if you_mean_string
					raise ArgumentError, "This slug (#{field_slug}) is associated to a string not a text. Use get_string() instead on instance (#{self.class.name} ##{self.id}).", caller
				else
					raise ArgumentError, "There isn't any text associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller
				end
			end

			# Get the object related to that field setting
			# 
			# @param field_slug [string] The slug of the field setting
			# @return [boolean]
			def has_text(field_slug)
				obj = Text
					.includes(:field_setting)
					.where(fieldable_id: self.id, fieldable_type: self.class.name)
					.where(binda_field_settings: { slug: field_slug })
					.where.not(binda_field_settings: { field_type: "string" })
					.first
				raise ArgumentError, "There isn't any text associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
				if obj.present?
					return !obj.content.nil?
				else
					return false
				end
			end

		end
	end
end