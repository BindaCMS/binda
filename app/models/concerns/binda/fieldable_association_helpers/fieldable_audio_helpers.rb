module Binda
	module FieldableAssociationHelpers
		module FieldableAudioHelpers
			# Check if the field has an attached audio
			# 
			# @param field_slug [string] The slug of the field setting
			# @return [boolean]
			def has_audio(field_slug)
				obj = self.audios.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
				# Alternative query
				# obj = Image.where(field_setting_id: FieldSetting.get_id( field_slug ), fieldable_id: self.id, fieldable_type: self.class.to_s ).first
				raise ArgumentError, "There isn't any audio associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
				return obj.audio.present?
			end

			# Get the audio url based on the size provided, 
			#   default is Carrierwave default (usually the real size)
			# 
			# @param field_slug [string] The slug of the field setting
			# @return [string] The url of the audio
			def get_audio_url(field_slug)
				get_audio_info( field_slug, 'url' )
			end

			# Get the audio path based on the size provided, 
			#   default is Carrierwave default (usually the real size)
			# 
			# @param field_slug [string] The slug of the field setting
			# @return [string] The url of the audio
			def get_audio_path(field_slug)
				get_audio_info( field_slug, 'path' )
			end

			# Get the object related to that field setting
			# 
			# @param field_slug [string] The slug of the field setting
			# @param info [string] String of the info to be retrieved
			# @return [string] The info requested if present
			# @return [boolean] Returns false if no info is found or if image isn't found
			def get_audio_info(field_slug, info)
				obj = self.audios.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
				# Alternative query
				# obj = audio.where(field_setting_id: FieldSetting.get_id( field_slug ), fieldable_id: self.id, fieldable_type: self.class.to_s ).first
				raise ArgumentError, "There isn't any audio associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
				if obj.audio.present?
					obj.audio.send(info)
				end
			end
		end
	end
end