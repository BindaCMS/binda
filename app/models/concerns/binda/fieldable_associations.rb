module Binda
	# Fieldable associations are Binda's core feature. 
	# 
	# They provide model classes with a collection of fields (texts, assets, dates and so on)
	#   to store data in a simple yet powerful way. It's possible to make use of a set of helpers to 
	#   retrieve fields data belonging to each model instance. See the following methods. 
	module FieldableAssociations

		extend ActiveSupport::Concern

		included do 
	    # Fieldable Associations 
	    # 
	    # If you add a new field remember to update:
	    #   - get_fieldables (see here below)
	    #   - get_field_types (see here below)
	    #   - component_params (app/controllers/binda/components_controller.rb)

	    has_many :texts,         as: :fieldable, dependent: :delete_all
	    has_many :strings,       as: :fieldable, dependent: :delete_all
	    has_many :dates,         as: :fieldable, dependent: :delete_all
	    has_many :galleries,     as: :fieldable, dependent: :delete_all
	    has_many :assets,        as: :fieldable, dependent: :delete_all
	    has_many :images,        as: :fieldable, dependent: :delete_all
	    has_many :videos,        as: :fieldable, dependent: :delete_all
	    has_many :radios,        as: :fieldable, dependent: :delete_all 
	    has_many :selections,    as: :fieldable, dependent: :delete_all 
	    has_many :checkboxes,    as: :fieldable, dependent: :delete_all 
	    # Repeaters need destroy_all, not delete_all
	    has_many :repeaters,     as: :fieldable, dependent: :destroy
			has_many :relations,     as: :fieldable, dependent: :destroy 


    	has_many :owner_relations, class_name: "RelationLink", 
                                dependent: :destroy, 
                                as: :dependent

	    # Owner are connected to its Dependents in a Active Relation
	    # meaning its possible to connect a Owner to as many Dependents
	    # as it's needed.
	    # 
	    # The current version support components and boards separately
	    has_many :owner_components, through: :owner_relations, 
	                                source: :owner

	    has_many :owner_boards, through: :owner_relations, 
	                            source: :owner

	    has_many :owner_repeaters, through: :owner_relations, 
	                            source: :owner 


	    accepts_nested_attributes_for :texts, :strings, :dates, :assets, :images, :videos, :galleries, :repeaters, :radios, :selections, :checkboxes, :relations, allow_destroy: true

			validates_associated :texts
			validates_associated :strings
			validates_associated :dates
			validates_associated :assets
			validates_associated :images
			validates_associated :videos
			validates_associated :repeaters
			validates_associated :radios
			validates_associated :selections
			validates_associated :checkboxes
			validates_associated :relations

      after_save :generate_fields

      # Uncomment these "validate do" loop to better debug validation.
      # This makes method gather errors of the associated records and
      # make them available to the instance object. After using this method 
      # you will be able to see the actual error inside `instance.errors` array.
      # Example: @component.errors #=> [ ... ]
      # 
		  # validate do |instance|
		  #   instance.texts.each do |text|
		  #   	binding.pry
		  #     next if text.valid?
		  #     text.errors.full_messages.each do |msg|
		  #       # you can customize the error message here:
		  #       errors[:base] << "Error in #{text.field_setting.name} (text): #{msg}"
		  #     end
		  #   end
		  # end
	
		end

		# Get the object related to that field setting
		# If the object doesn't exists yet it will return nil
		# 
		# @param  field_slug [string] The slug of the field setting
		# @return [string] Returns the content of the text 
		# @return [error]  Raise an error if no record is found
		def get_text field_slug 
			obj = self.texts.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) && t.type != 'Binda::String' }	
			unless obj.nil?
				obj.content
			else
				you_mean_string = !self.strings.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) && t.type = 'Binda::String' }.nil?
				if you_mean_string
					raise ArgumentError, "This slug (#{field_slug}) is associated to a string not a text. Use get_string() instead on instance (#{self.class.name} ##{self.id}).", caller
				else
					raise ArgumentError, "There isn't any text associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller
				end
			end
		end

		# Get the object related to that field setting
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [boolean]
		def has_text field_slug 
			obj = self.texts.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) && t.type != 'Binda::String' }
			raise ArgumentError, "There isn't any text associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			if obj.present?
				return !obj.content.blank?
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
		def get_string field_slug 
			obj = self.strings.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) && t.type == 'Binda::String' }
			unless obj.nil?
				obj.content
			else
				you_mean_text = !self.strings.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) && t.type = 'Binda::Text' }.nil?
				if you_mean_text
					raise ArgumentError, "This slug (#{field_slug}) is associated to a text not a string. Use get_text() instead on instance (#{self.class.name} ##{self.id}).", caller
				else
					raise ArgumentError, "There isn't any string associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller
				end
			end
		end

		# Get the object related to that field setting
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [boolean]
		def has_string field_slug 
			obj = self.strings.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) && t.type == 'Binda::String' }
			raise ArgumentError, "There isn't any string associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
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
			obj = self.images.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			# Alternative query
			# obj = Image.where(field_setting_id: FieldSetting.get_id( field_slug ), fieldable_id: self.id, fieldable_type: self.class.to_s ).first
			raise ArgumentError, "There isn't any image associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			if obj.image.present?
				if obj.image.respond_to?(size) && %w[thumb medium large].include?(size)
					obj.image.send(size).send(info)
				else
					obj.image.send(info)
				end
			end
		end

		def get_image_dimension field_slug
			obj = self.images.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }

			raise ArgumentError, "There isn't any image associated to  the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			if obj.image.present?
				if obj.image.respond_to?(size) && %w[thumb medium large].include?(size)
					obj.image.send(size).send(info)
				else
					obj.image.send(info)
				end
			end
		end

		# Check if the field has an attached video
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [boolean]
		def has_video field_slug 
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
		def get_video_url field_slug
			get_video_info( field_slug, 'url' )
		end

		# Get the video path based on the size provided, 
		#   default is Carrierwave default (usually the real size)
		# 
		# @param field_slug [string] The slug of the field setting
		# @param size [string] The size. It can be 'thumb' 200x200 cropped, 
		#   'medium' 700x700 max size, 'large' 1400x1400 max size, or blank
		# @return [string] The url of the video
		def get_video_path field_slug
			get_video_info( field_slug, 'path' )
		end

		# Get the object related to that field setting
		# 
		# @param field_slug [string] The slug of the field setting
		# @param info [string] String of the info to be retrieved
		# @return [string] The info requested if present
		# @return [boolean] Returns false if no info is found or if image isn't found
		def get_video_info field_slug, info 
			obj = self.videos.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			# Alternative query
			# obj = video.where(field_setting_id: FieldSetting.get_id( field_slug ), fieldable_id: self.id, fieldable_type: self.class.to_s ).first
			raise ArgumentError, "There isn't any video associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			if obj.video.present?
				obj.video.send(info)
			end
		end

		# Check if the field has an attached date
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [datetime] The date
		# @return [boolean] Reutrn false if nothing is found
		def has_date field_slug 
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
		def get_date field_slug 
			obj = self.dates.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			raise ArgumentError, "There isn't any date associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			obj.date
		end

		# Check if exists any repeater with that slug
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [boolean]
		def has_repeater field_slug 
			obj = self.repeaters.find_all{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			raise ArgumentError, "There isn't any repeater associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			return obj.present?
		end

		# Get the all repeater instances
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [hash]
		def get_repeater field_slug 
			obj = self.repeaters.find_all{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			raise ArgumentError, "There isn't any repeater associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			obj.sort_by(&:position)
		end

		# Get the radio choice
		# 
		# If by mistake the Radio instance has many choices associated, 
		#   only the first one will be retrieved.
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [hash] A hash of containing the label and value of the selected choice. `{ label: 'the label', value: 'the value'}`
		def get_radio_choice field_slug
			field_setting = FieldSetting.find_by(slug:field_slug)
			obj = self.radios.find{ |t| t.field_setting_id == field_setting.id }
			raise ArgumentError, "There isn't any radio associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			raise "There isn't any choice available for the current radio (#{field_slug}) on instance (#{self.class.name} ##{self.id})." unless field_setting.choices.any?
			return { label: obj.choices.first.label, value: obj.choices.first.value }
		end

		# Get the select choices
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [hash] A hash of containing the label and value of the selected choice. `{ label: 'the label', 'value': 'the value'}`
		def get_selection_choice field_slug
			field_setting = FieldSetting.find_by(slug:field_slug)
			obj = self.selections.find{ |t| t.field_setting_id == field_setting.id }
			raise ArgumentError, "There isn't any radio associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			raise "There isn't any choice available for the current radio (#{field_slug}) on instance (#{self.class.name} ##{self.id})." unless field_setting.choices.any?
			return { label: obj.choices.first.label, value: obj.choices.first.value }
		end

		# Get the checkbox choice
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [array] An array of labels and values of the selected choices. `[{ label: '1st label', value: '1st-value'}, { label: '2nd label', value: '2nd-value'}]`
		def get_checkbox_choices field_slug
			field_setting = FieldSetting.find_by(slug:field_slug)
			obj = self.checkboxes.find{ |t| t.field_setting_id == field_setting.id }
			raise ArgumentError, "There isn't any checkbox associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			raise "There isn't any choice available for the current radio (#{field_slug}) on instance (#{self.class.name} ##{self.id})." unless field_setting.choices.any?
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
		def has_related_components field_slug
			obj = self.relations.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			raise ArgumentError, "There isn't any related field associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			return obj.dependent_relations.any?
		end

		# Alias for has_related_components
		def has_dependent_components field_slug
			has_related_components field_slug
		end

		# Get related components
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [array] An array of components
		def get_related_components field_slug
			obj = self.relations.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			raise ArgumentError, "There isn't any related field associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			return obj.dependent_relations.map{|relation| relation.dependent}
		end

		# Alias for get_related_components
		def get_dependent_components field_slug
			get_related_components field_slug
		end

		# Get all components which owns a relation where the current instance is a dependent
		# 
		# @param field_slug [string] The slug of the field setting of the relation
		# @return [array] An array of components and/or boards
		def get_owner_components field_slug
			# obj = self.owner_relations.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			obj = Relation.where(field_setting_id: B.get_field_settings(field_slug)).includes(dependent_relations: :dependent).where(binda_relation_links: {dependent_type: self.class.name})
			raise ArgumentError, "There isn't any relation associated to the current slug (#{field_slug}) where the current instance (#{self.class.name} ##{self.id}) is a dependent.", caller if obj.nil?
			return obj
		end

		# Check if has related boards
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [boolean]
		def has_related_boards field_slug
			obj = self.relations.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			raise ArgumentError, "There isn't any related field associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			return obj.dependent_relations.any?
		end

		# Get related boards
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [array] An array of boards
		def get_related_boards field_slug
			obj = self.relations.find{ |t| t.field_setting_idid == FieldSetting.get_id( field_slug ) }
			raise ArgumentError, "There isn't any related field associated to the current slug (#{field_slug}) on instance (#{self.class.name} ##{self.id}).", caller if obj.nil?
			return obj.dependent_relations.map{|relation| relation.dependent}
		end

		# Find or create a field by field setting and field type
		# 
		# This is used in Binda's editor views.
		#   
		# Please, check the code to know more about the way this method works as it's pretty complex yet important.
		# 
		# @param field_setting_id [string] The field setting id
		# @param field_type [string] THe field type
		def find_or_create_a_field_by field_setting_id, field_type
			if FieldSetting.get_field_classes.include?( field_type.classify ) && field_setting_id.is_a?( Integer )
				# It's mandatory to use `select{}.first`!!! 
				# If you use any ActiveRecord method (like `where` of `find`) the validation errors are wiped out 
				# from the object and not rendered next to the form in the editor view
				obj = self.send( field_type.pluralize ).select{|rf| rf.field_setting_id == field_setting_id}.first
				if obj.nil?
					# As we are using the `select{}.first` method, asynchronous requests passing through 
					# this method will create some inconsistentcy between this `self` object and the real object. 
					# In other words `self` should be reloaded, but we won't reload it otherwise we will 
					# erase the errors shipped with it initially. Therefore we will check again with `find_or_create_by!`.
					# This leads to another issue, which is: errors coming from asynchronous requests won't be considered
					# as the `self` object is the initial one, not the "updated" one. At the current time this is not
					# a problem because the only asynchronous requests are for brand new records which don't need validation.
					return self.send( field_type.pluralize ).find_or_create_by!( field_setting_id: field_setting_id ) 
				else
					return obj
				end
			else
				raise ArgumentError, "One parameter in find_or_create_a_field_by() is not correct on instance (#{self.class.name} ##{self.id}).", caller
			end
		end

    # This method is called upon the creation/update of a fieldable record (component, board or repeater) 
    #   and generates all fields related to each field settings which belongs to it.
    # 
    # This avoids any situation in which, for example, a component have a field setting for a text
    #   but there is no text (meaning `Binda::Text` instance) that correspond to that field setting.
    #   This causes issues when looping a bunch of components which will thow a error if you try to access
    #   a component field, as some might have it some might not. This make sure that you can always expect 
    #   to find a field instance which might be empty, but certainly it exists.
    #   
    # TODO check if find_or_create_a_field_by method should be used instead (it's used in editors views)
    # 
    def generate_fields
  		# If this is a component or a board
    	if self.respond_to?('structure')
	    	field_settings = FieldSetting.where(field_group_id: FieldGroup.where(structure_id: self.structure.id))
	    	field_settings.each do |field_setting|
	    		"Binda::#{field_setting.field_type.classify}".constantize.find_or_create_by!(
	    			fieldable_id: self.id, fieldable_type: self.class.name, field_setting_id: field_setting.id )
	    	end
    	# If this is a repeater
    	else
    		self.field_setting.children.each do |field_setting|
	    		"Binda::#{field_setting.field_type.classify}".constantize.find_or_create_by!(
	    			fieldable_id: self.id, fieldable_type: self.class.name, field_setting_id: field_setting.id )
    		end
	    end
    end

		# TODO: Update all helpers replacing `find` method with ruby `select`. 
		# This should improve performance avoiding generating useless ActiveRecord objects.

	end
end