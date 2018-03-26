module Binda
	module FieldableAssociationHelpers
		module FieldableRepeaterHelpers	
			# Check if exists any repeater with that slug
			# 
			# @param field_slug [string] The slug of the field setting
			# @return [boolean]
			def has_repeaters(field_slug)
				obj = self.repeaters.find_all{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
				raise ArgumentError, "There isn't any repeater associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
				return obj.present?
			end
			def has_repeater(field_slug)
				has_repeaters(field_slug)
			end

			# Get the all repeater instances sorted by position
			# 
			# @param field_slug [string] The slug of the field setting
			# @return [array] An array of repeater items which have all sorts of fields attached
			def get_repeaters(field_slug)
				obj = self.repeaters.find_all{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
				raise ArgumentError, "There isn't any repeater associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
				obj.sort_by(&:position)
			end
			def get_repeater(field_slug)
				get_repeaters(field_slug)
			end

		end
	end
end