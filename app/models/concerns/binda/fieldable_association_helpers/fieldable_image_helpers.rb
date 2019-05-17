module Binda
	module FieldableAssociationHelpers
		module FieldableImageHelpers

			# Check if the field has an attached image
			#
			# @param field_slug [string] The slug of the field setting
			# @return [boolean]
			def has_image(field_slug)
				obj = self.images.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
				# Alternative query
				# obj = Image.where(field_setting_id: FieldSetting.get_id( field_slug ), fieldable_id: self.id, fieldable_type: self.class.to_s ).first
				raise ArgumentError, "There isn't any image associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
				return obj.image.present?
			end

			# Get the image url based on the size provided,
			#   default is Carrierwave default (usually the real size)
			#
			# @param field_slug [string] The slug of the field setting
			# @param size [string] The size. It can be 'thumb' 200x200 cropped.
			# @return [string] The url of the image
			def get_image_url(field_slug, size = '')
				get_image_info( field_slug, size, 'url' )
			end

			# Get the image path based on the size provided,
			#   default is Carrierwave default (usually the real size)
			#
			# @param field_slug [string] The slug of the field setting
			# @param size [string] The size. It can be 'thumb' 200x200 cropped.
			# @return [string] The url of the image
			def get_image_path(field_slug, size = '')
				get_image_info( field_slug, size, 'path' )
			end

			# Get the object related to that field setting
			#
			# @param field_slug [string] The slug of the field setting
			# @param size [string] The size. It can be 'thumb' 200x200 cropped.
			# @param info [string] String of the info to be retrieved
			# @return [string] The info requested if present
			# @return [boolean] Returns false if no info is found or if image isn't found
			def get_image_info(field_slug, size, info)
				obj = self.images.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
				# Alternative query
				# obj = Image.where(field_setting_id: FieldSetting.get_id( field_slug ), fieldable_id: self.id, fieldable_type: self.class.to_s ).first
				raise ArgumentError, "There isn't any image associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
				if obj.image.present? && obj.image.respond_to?(size) && %w[thumb].include?(size)
						obj.image.send(size).send(info)
				elsif obj.image.present?
					obj.image.send(info)
				else
					raise "Looks like the image you are looking for isn't present. See field setting with slug=\"#{field_slug}\" on component with id=\"#{self.id}\""
				end
			end

			# Get image size
			#
			# @param field_slug [string] The slug of the field setting
			# @return [float] with image type
			def get_image_size(field_slug)
				obj = self.images.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
	     	return bytes_to_megabytes(obj.file_size)
			end

			# Get image type
			#
			# @param field_slug [string] The slug of the field setting
			# @return [string] with image type
			def get_image_mime_type(field_slug)
				obj = self.images.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
	     	return obj.content_type
			end

			# Get image dimension
			#
			# @param field_slug [string] The slug of the field setting
			# @return [hash] with width and height as floats
			def get_image_dimension(field_slug)
				obj = self.images.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
	     	return { width: obj.file_width, height: obj.file_height }
			end

			# Convert bytes to megabites
		    def bytes_to_megabytes bytes
		      (bytes.to_f / 1.megabyte).round(2)
		    end

		end
	end
end
