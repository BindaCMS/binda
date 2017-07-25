module Binda
	module ComponentModelHelper
		# 
		# Component helpers are supposed to simplify common operation like 
		#   retrieving data belonging to the component instance (texts, assets, dates and so on)

		extend ActiveSupport::Concern

		# Get the object related to that field setting
		# If the object doesn't exists yet it will return nil
		# 
		# @param  field_slug [string] The slug of the field setting
		# @return [string] Returns the content of the string/text 
		# @return [nil]    Returns null if it's empty or it doesn't exists
		def get_text field_slug 
			text = self.texts.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			text.content unless text.nil?
		end

		# Get the object related to that field setting
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [boolean]
		def has_text field_slug 
			obj = self.texts.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			if obj.present?
				return !obj.content.blank?
			else
				return false
			end
		end

		# Check if the field has an attached image
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [boolean]
		def has_image field_slug 
			obj = self.assets.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }.image
			return obj.present?
		end

		# Get the image url based on the size provided, 
		#   default is Carrierwave default (usually the real size)
		# 
		# @param field_slug [string] The slug of the field setting
		# @param size [string] The size. It can be 'thumb' 200x200 cropped, 
		#   'medium' 700x700 max size, 'large' 1400x1400 max size, or blank
 		# @return [string] The url of the image
		def get_image_url field_slug, size = '' 
			get_image_info( field_slug, size, 'url' )
		end

		# Get the image path based on the size provided, 
		#   default is Carrierwave default (usually the real size)
		# 
		# @param field_slug [string] The slug of the field setting
		# @param size [string] The size. It can be 'thumb' 200x200 cropped, 
		#   'medium' 700x700 max size, 'large' 1400x1400 max size, or blank
 		# @return [string] The url of the image
		def get_image_path field_slug, size = '' 
			get_image_info( field_slug, size, 'path' )
		end

		# Get the object related to that field setting
		# 
		# @param field_slug [string] The slug of the field setting
		# @param size [string] The size. It can be 'thumb' 200x200 cropped, 
		#   'medium' 700x700 max size, 'large' 1400x1400 max size, or blank
		# @param info [string] String of the info to be retrieved
 		# @return [string] The info requested if present
		# @return [boolean] Returns false if no info is found or if image isn't found
		def get_image_info field_slug, size, info 
			obj = self.assets.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			if obj.image.present?
				if obj.image.respond_to?(size) && %w[thumb medium large].include?(size)
					obj.image.send(size).send(info)
				else
					obj.image.send(info)
				end
			end
		end

		# Check if the field has an attached date
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [datetime] The date
		# @return [boolean] Reutrn false if nothing is found
 		def has_date field_slug 
			obj = self.dates.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
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
		def get_date field_slug 
			date = self.dates.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			date.date unless date.nil?
		end

		# Check if exists any repeater with that slug
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [boolean]
	  def has_repeater field_slug 
	    obj = self.repeaters.find_all{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
	    return obj.present?
	  end

	  # Get the all repeater instances
	  # 
		# @param field_slug [string] The slug of the field setting
		# @return [hash]
	  def get_repeater field_slug 
	    repeater = self.repeaters.find_all{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
	    repeater.sort_by(&:position) unless repeater.nil?
	  end

		# Find or create a field by field setting and field type
		# This is used in Binda's form
		# 
		# @param field_setting_id [string] The field setting id
		# @param field_type [string] THe field type
		def find_or_create_a_field_by field_setting_id, field_type
			if FieldSetting.get_fieldables.include?( field_type.capitalize ) && field_setting_id.is_a?( Integer )
				self.send( field_type.pluralize ).find_or_create_by( field_setting_id: field_setting_id )
			else
				raise ArgumentError, "One parameter of find_or_create_a_field_by() is not correct.", caller
			end
		end

		# Get the raidio choice
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [object] The active record object of the selected choice
		def get_radio_choice field_slug
			radio = self.radios.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			radio.chioce
		end

		# Get the select choices
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [array] An array containing the selected choices objects
		def get_select_choices field_slug
			# select cannot be chosen has variable name, therefore is prefixed with '_'
			_select = self.selects.find{ |t| t.field_setting_id = FieldSetting.get_id( field_slug ) }
			_select.choices
		end

		# Get the radio choice
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [object] The active record object of the selected choice
		def get_radio_choice field_slug
			# select cannot be chosen has variable name, therefore is prefixed with '_'
			radio = self.radios.find{ |t| t.field_setting_id = FieldSetting.get_id( field_slug ) }
			radio.choices.first
		end

	end
end