module Binda
	module ComponentHelpers 
		extend ActiveSupport::Concern

		def get_text( field_slug )
			# Get the object related to that field setting
			self.texts.find{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }.content
		end

		def has_text( field_slug )
			# Get the object related to that field setting
			obj = self.texts.find{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }
			if obj.present?
				return !obj.content.blank?
			else
				return false
			end
		end

		def has_image( field_slug )
			# Check if the field has an attached image
			obj = self.assets.find{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }.image
			return obj.present?
		end

		def get_image_url( field_slug, size = '' )
			get_image_info( field_slug, size, 'url' )
		end

		def get_image_path( field_slug, size = '' )
			get_image_info( field_slug, size, 'path' )
		end

		def get_image_info( field_slug, size, info )
			# Get the object related to that field setting
			obj = self.assets.find{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }
			if obj.image.present?
				if obj.image.respond_to?(size) && %w[thumb medium large].include?(size)
					obj.image.send(size).send(info)
				else
					obj.image.send(info)
				end
			end
		end

		def has_date( field_slug )
			# Check if the field has an attached date
			obj = self.dates.find{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }
			if obj.present?
				return !obj.date.nil?
			else
				return false
			end
		end

		def get_date( field_slug )
			# Get the object related to that field setting
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