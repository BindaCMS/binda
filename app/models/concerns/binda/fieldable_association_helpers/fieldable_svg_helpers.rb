module Binda
	module FieldableAssociationHelpers
		module FieldableSvgHelpers
			# Check if the field has an attached audio
			# 
			# @param field_slug [string] The slug of the field setting
			# @return [boolean]
			def has_svg(field_slug)
				obj = self.svgs.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
				# Alternative query
				# obj = Image.where(field_setting_id: FieldSetting.get_id( field_slug ), fieldable_id: self.id, fieldable_type: self.class.to_s ).first
				raise ArgumentError, "There isn't any svg associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
				return obj.svg.present?
			end

			# Get the svg url based on the size provided, 
			#   default is Carrierwave default (usually the real size)
			# 
			# @param field_slug [string] The slug of the field setting
			# @param size [string] The size. It can be 'thumb' 200x200 cropped, 
			#   'medium' 700x700 max size, 'large' 1400x1400 max size, or blank
			# @return [string] The url of the svg
			def get_svg_url(field_slug)
				get_svg_info( field_slug, 'url' )
			end

			# Get the svg path based on the size provided, 
			#   default is Carrierwave default (usually the real size)
			# 
			# @param field_slug [string] The slug of the field setting
			# @param size [string] The size. It can be 'thumb' 200x200 cropped, 
			#   'medium' 700x700 max size, 'large' 1400x1400 max size, or blank
			# @return [string] The url of the svg
			def get_svg_path(field_slug)
				get_svg_info( field_slug, 'path' )
			end

			# Get the object related to that field setting
			# 
			# @param field_slug [string] The slug of the field setting
			# @param info [string] String of the info to be retrieved
			# @return [string] The info requested if present
			# @return [boolean] Returns false if no info is found or if image isn't found
			def get_svg_info(field_slug, info)
				obj = self.svgs.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
				# Alternative query
				# obj = svg.where(field_setting_id: FieldSetting.get_id( field_slug ), fieldable_id: self.id, fieldable_type: self.class.to_s ).first
				raise ArgumentError, "There isn't any svg associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
				if obj.svg.present?
					obj.svg.send(info)
				end
			end

			def get_svg_size(field_slug)
				obj = self.svgs.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
	     	return bytes_to_megabytes(obj.file_size)
			end

			# Get svg type
			# 
			# @param field_slug [string] The slug of the field setting
			# @return [string] with svg type
			def get_svg_mime_type(field_slug)
				obj = self.svgs.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
	     	return obj.content_type
			end

				# Convert bytes to megabites
		    def bytes_to_megabytes bytes
		      (bytes.to_f / 1.megabyte).round(2)
		    end
		end
	end
end