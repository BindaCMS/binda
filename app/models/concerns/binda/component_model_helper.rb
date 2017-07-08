module Binda
	module ComponentModelHelper
		# Component helpers are supposed to simplify common operation like 
		# retrieving data belonging to the component instance (texts, assets, dates and so on)

		extend ActiveSupport::Concern


		# Get the object related to that field setting
		def get_text( field_slug )
			self.texts.find{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }.content
		end

		# Get the object related to that field setting
		def has_text( field_slug )
			obj = self.texts.find{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }
			if obj.present?
				return !obj.content.blank?
			else
				return false
			end
		end

		# Check if the field has an attached image
		def has_image( field_slug )
			obj = self.assets.find{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }.image
			return obj.present?
		end

		def get_image_url( field_slug, size = '' )
			get_image_info( field_slug, size, 'url' )
		end

		def get_image_path( field_slug, size = '' )
			get_image_info( field_slug, size, 'path' )
		end

		# Get the object related to that field setting
		def get_image_info( field_slug, size, info )
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
		def has_date( field_slug )
			obj = self.dates.find{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }
			if obj.present?
				return !obj.date.nil?
			else
				return false
			end
		end

		# Get the object related to that field setting
		def get_date( field_slug )
			self.dates.find{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }.date
		end

	  def has_repeater( field_slug )
	    obj = self.repeaters.find_all{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }
	    return obj.present?
	  end

	  def get_repeater( field_slug )
	    self.repeaters.find_all{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }.sort_by(&:position)
	  end
	end
end