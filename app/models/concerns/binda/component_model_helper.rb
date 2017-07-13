module Binda
	module ComponentModelHelper
		# Component helpers are supposed to simplify common operation like 
		# retrieving data belonging to the component instance (texts, assets, dates and so on)

		extend ActiveSupport::Concern

		# Get the object related to that field setting
		# If the object doesn't exists yet it will return nil
		# 
		# @return [string] The content of the string/text or nil if it's empty or it doesn't exists
		def get_text field_slug 
			text = self.texts.find{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }
			text.content unless text.nil?
		end

		# Get the object related to that field setting
		def has_text field_slug 
			obj = self.texts.find{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }
			if obj.present?
				return !obj.content.blank?
			else
				return false
			end
		end

		# Check if the field has an attached image
		def has_image field_slug 
			obj = self.assets.find{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }.image
			return obj.present?
		end

		def get_image_url field_slug, size = '' 
			get_image_info( field_slug, size, 'url' )
		end

		def get_image_path field_slug, size = '' 
			get_image_info( field_slug, size, 'path' )
		end

		# Get the object related to that field setting
		def get_image_info field_slug, size, info 
			obj = self.assets.find{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }
			if obj.image.present?
				if obj.image.respond_to?(size) && %w[thumb medium large].include?(size)
					obj.image.send(size).send(info)
				else
					obj.image.send(info)
				end
			end
		end

		# Check if the field has an attached date
		def has_date field_slug 
			obj = self.dates.find{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }
			if obj.present?
				return !obj.date.nil?
			else
				return false
			end
		end

		# Get the object related to that field setting
		def get_date field_slug 
			date = self.dates.find{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }
			date.date unless date.nil?
		end

	  def has_repeater field_slug 
	    obj = self.repeaters.find_all{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }
	    return obj.present?
	  end

	  def get_repeater field_slug 
	    repeater = self.repeaters.find_all{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }
	    repeater.sort_by(&:position) unless repeater.nil?
	  end

		def find_or_create_a_field_by field_setting_id, field_type
			if Binda::FieldSetting.get_fieldables.include?( field_type.capitalize ) && field_setting_id.is_a?( Integer )
				self.send( field_type.pluralize ).find_or_create_by( field_setting_id: field_setting_id )
			else
				raise ArgumentError, "A parameter of the method 'find_or_create_a_field_by' is not correct.", caller
			end
		end

		def get_radio_choice field_slug
			radio = self.radios.find{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }
			radio.get_choice() unless radio.nil?
		end

	end
end