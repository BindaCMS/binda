module Binda
	module FieldableAssociationHelpers
		module FieldableVideoHelpers
			
			# Check if the field has an attached video
			# 
			# @param field_slug [string] The slug of the field setting
			# @return [boolean]
			def has_video(field_slug)
				obj = self.videos.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
				# Alternative query
				# obj = Image.where(field_setting_id: FieldSetting.get_id( field_slug ), fieldable_id: self.id, fieldable_type: self.class.to_s ).first
				raise ArgumentError, "There isn't any video associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
				return obj.video.present?
			end

			# Get the video url based on the size provided, 
			#   default is Carrierwave default (usually the real size)
			# 
			# @param field_slug [string] The slug of the field setting
			# @return [string] The url of the video
			def get_video_url(field_slug)
				get_video_info( field_slug, 'url' )
			end

			# Get the video path based on the size provided, 
			#   default is Carrierwave default (usually the real size)
			# 
			# @param field_slug [string] The slug of the field setting
			# @return [string] The url of the video
			def get_video_path(field_slug)
				get_video_info( field_slug, 'path' )
			end

			# Get the object related to that field setting
			# 
			# @param field_slug [string] The slug of the field setting
			# @param info [string] String of the info to be retrieved
			# @return [string] The info requested if present
			# @return [boolean] Returns false if no info is found or if image isn't found
			def get_video_info(field_slug, info)
				obj = self.videos.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
				# Alternative query
				# obj = video.where(field_setting_id: FieldSetting.get_id( field_slug ), fieldable_id: self.id, fieldable_type: self.class.to_s ).first
				raise ArgumentError, "There isn't any video associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
				if obj.video.present?
					obj.video.send(info)
				end
			end
		end
	end
end
