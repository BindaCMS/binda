module Binda
	module FieldableAssociationHelpers

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

		# Get the object related to that field setting
		# If the object doesn't exists yet it will return nil
		# 
		# @param  field_slug [string] The slug of the field setting
		# @return [string] Returns the content of the string 
		# @return [error]  Raise an error if no record is found
		def get_string(field_slug)
			obj = Text
				.includes(:field_setting)
				.where(fieldable_id: self.id, fieldable_type: self.class.name)
				.where(binda_field_settings: { slug: field_slug, field_type: "string" })
				.first
			unless obj.nil?
				# to_s ensures the returned object is class String
				obj.content.to_s
			else
				check_string_error field_slug
			end
		end

		# Check why get_string doesn't return a value
		# This method isn't supposed to be used by anything other than get_string method
		def check_string_error(field_slug)
			you_mean_text = !self.strings.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) && t.type == 'Binda::Text' }.nil?
			if you_mean_text
				raise ArgumentError, "This slug (#{field_slug}) is associated to a text not a string. Use get_text() instead on instance (#{self.class.name} ##{self.id}).", caller
			else
				raise ArgumentError, "There isn't any string associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller
			end
		end

		# Get the object related to that field setting
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [boolean]
		def has_string(field_slug)
			obj = Text
				.includes(:field_setting)
				.where(fieldable_id: self.id, fieldable_type: self.class.name)
				.where(binda_field_settings: { slug: field_slug, field_type: "string" })
				.first
			raise ArgumentError, "There isn't any string associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			if obj.present?
				return !obj.content.nil?
			else
				return false
			end
		end

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
		# @param size [string] The size. It can be 'thumb' 200x200 cropped, 
		#   'medium' 700x700 max size, 'large' 1400x1400 max size, or blank
		# @return [string] The url of the image
		def get_image_url(field_slug, size = '')
			get_image_info( field_slug, size, 'url' )
		end

		# Get the image path based on the size provided, 
		#   default is Carrierwave default (usually the real size)
		# 
		# @param field_slug [string] The slug of the field setting
		# @param size [string] The size. It can be 'thumb' 200x200 cropped, 
		#   'medium' 700x700 max size, 'large' 1400x1400 max size, or blank
		# @return [string] The url of the image
		def get_image_path(field_slug, size = '')
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
				raise "Looks like the image you are looking for isn't present. See field setting with slug=\"#{field_slug}\" on component with id=\"self.id\""
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

    # Convert bytes to megabites
    def bytes_to_megabytes bytes
      (bytes.to_f / 1.megabyte).round(2)
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
		# @param size [string] The size. It can be 'thumb' 200x200 cropped, 
		#   'medium' 700x700 max size, 'large' 1400x1400 max size, or blank
		# @return [string] The url of the video
		def get_video_url(field_slug)
			get_video_info( field_slug, 'url' )
		end

		# Get the video path based on the size provided, 
		#   default is Carrierwave default (usually the real size)
		# 
		# @param field_slug [string] The slug of the field setting
		# @param size [string] The size. It can be 'thumb' 200x200 cropped, 
		#   'medium' 700x700 max size, 'large' 1400x1400 max size, or blank
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
		# @param size [string] The size. It can be 'thumb' 200x200 cropped, 
		#   'medium' 700x700 max size, 'large' 1400x1400 max size, or blank
		# @return [string] The url of the audio
		def get_audio_url(field_slug)
			get_audio_info( field_slug, 'url' )
		end

		# Get the audio path based on the size provided, 
		#   default is Carrierwave default (usually the real size)
		# 
		# @param field_slug [string] The slug of the field setting
		# @param size [string] The size. It can be 'thumb' 200x200 cropped, 
		#   'medium' 700x700 max size, 'large' 1400x1400 max size, or blank
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

		# Check if the field has an attached date
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [datetime] The date
		# @return [boolean] Reutrn false if nothing is found
		def has_date(field_slug)
			obj = self.dates.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			raise ArgumentError, "There isn't any date associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
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
		def get_date(field_slug)
			obj = self.dates.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			raise ArgumentError, "There isn't any date associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			obj.date
		end

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

		# Get the radio choice
		# 
		# If by mistake the Radio instance has many choices associated, 
		#   only the first one will be retrieved.
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [hash] A hash of containing the label and value of the selected choice. `{ label: 'the label', value: 'the value'}`
		def get_radio_choice(field_slug)
			field_setting = FieldSetting.find_by(slug:field_slug)
			obj = self.radios.find{ |t| t.field_setting_id == field_setting.id }
			raise ArgumentError, "There isn't any radio associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			raise "There isn't any choice available for the current radio (#{field_slug}) on instance (#{self.class.name} ##{self.id})." unless obj.choices.any?
			return { label: obj.choices.first.label, value: obj.choices.first.value }
		end

		# Get the select choices
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [hash] A hash of containing the label and value of the selected choice. `{ label: 'the label', 'value': 'the value'}`
		def get_selection_choice(field_slug)
			field_setting = FieldSetting.find_by(slug:field_slug)
			obj = self.selections.find{ |t| t.field_setting_id == field_setting.id }
			raise ArgumentError, "There isn't any selection associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			raise "There isn't any choice available for the current selection (#{field_slug}) on instance (#{self.class.name} ##{self.id})." unless field_setting.choices.any?
			return { label: obj.choices.first.label, value: obj.choices.first.value }
		end

		# Get the select choices
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [array] An array of hashes of containing label and value of the selected choices. `{ label: 'the label', 'value': 'the value'}`
		def get_selection_choices(field_slug)
			field_setting = FieldSetting.find_by(slug:field_slug)
			obj = self.selections.find{ |t| t.field_setting_id == field_setting.id }
			raise ArgumentError, "There isn't any selection associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			raise "There isn't any choice available for the current selection (#{field_slug}) on instance (#{self.class.name} ##{self.id})." unless field_setting.choices.any?
			return obj.choices.map{|choice| { label: choice.label, value: choice.value }}
		end

		# Get the checkbox choice
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [array] An array of labels and values of the selected choices. `[{ label: '1st label', value: '1st-value'}, { label: '2nd label', value: '2nd-value'}]`
		def get_checkbox_choices(field_slug)
			field_setting = FieldSetting.find_by(slug:field_slug)
			obj = self.checkboxes.find{ |t| t.field_setting_id == field_setting.id }
			raise ArgumentError, "There isn't any checkbox associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			raise "There isn't any choice available for the current checkbox (#{field_slug}) on instance (#{self.class.name} ##{self.id})." unless field_setting.choices.any?
			obj_array = []
			obj.choices.order('label').each do |o|
				obj_array << { label: o.label, value: o.value }
			end
			return obj_array
		end

		# Check if has related components
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [boolean]
		def has_related_components(field_slug)
			obj = self.relations.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			raise ArgumentError, "There isn't any related field associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			return obj.dependent_relations.any?
		end

		# Alias for has_related_components
		def has_dependent_components(field_slug)
			has_related_components(field_slug)
		end

		# Get related components
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [array] An array of components
		def get_related_components(field_slug)
			obj = self.relations.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			raise ArgumentError, "There isn't any related field associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			return obj.dependent_relations.map{|relation| relation.dependent}
		end

		# Alias for get_related_components
		def get_dependent_components(field_slug)
			get_related_components(field_slug)
		end

		# Get all components which owns a relation where the current instance is a dependent
		# 
		# @param field_slug [string] The slug of the field setting of the relation
		# @return [array] An array of components and/or boards
		def get_owner_components(field_slug)
			# obj = self.owner_relations.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			obj = Relation.where(field_setting_id: B.get_field_settings(field_slug)).includes(dependent_relations: :dependent).where(binda_relation_links: {dependent_type: self.class.name})
			raise ArgumentError, "There isn't any relation associated to the current slug (#{field_slug}) where the current instance (#{self.class.name} ##{self.id}) is a dependent.", caller if obj.nil?
			return obj
		end

		# Check if has related boards
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [boolean]
		def has_related_boards(field_slug)
			obj = self.relations.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			raise ArgumentError, "There isn't any related field associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			return obj.dependent_relations.any?
		end

		# Get related boards
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [array] An array of boards
		def get_related_boards(field_slug)
			obj = self.relations.find{ |t| t.field_setting_idid == FieldSetting.get_id( field_slug ) }
			raise ArgumentError, "There isn't any related field associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			return obj.dependent_relations.map{|relation| relation.dependent}
		end
	end
end