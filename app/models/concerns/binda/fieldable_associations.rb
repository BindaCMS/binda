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

			# children_fieldable_relates "names" the Association join table for accessing through the children_fieldable association
			has_many :active_relationships, class_name: "Relationship", dependent: :destroy, as: :children_related
			# parent_fieldable_relates "names" the Association join table for accessing through the parent_fieldable association
			has_many :passive_relationships, class_name: "Relationship", dependent: :destroy, as: :parent_related

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
			has_many :related_fields, as: :fieldable, dependent: :destroy

	    accepts_nested_attributes_for :related_fields, :texts, :strings, :dates, :assets, :images, :videos, :galleries, :repeaters, :radios, :selections, :checkboxes, allow_destroy: true
      
      # YOU SHOULDN'T USE THIS METHOD UNTIL IT'S OPTIMIZED
=begin
      after_save :generate_fields
=end
		end

		# Get the object related to that field setting
		# If the object doesn't exists yet it will return nil
		# 
		# @param  field_slug [string] The slug of the field setting
		# @return [string] Returns the content of the text 
		# @return [error]  Raise an error if no record is found
		def get_text field_slug 
			obj = self.texts.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) && t.type = 'Binda::Text' }	
			unless obj.nil?
				obj.content
			else
				you_mean_string = !self.strings.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) && t.type = 'Binda::String' }.nil?
				if you_mean_string
					raise ArgumentError, "This slug is associated to a string not a text. Use get_string() instead.", caller
				else
					raise ArgumentError, "There isn't any text associated to the current slug.", caller
				end
			end
		end

		# Get the object related to that field setting
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [boolean]
		def has_text field_slug 
			obj = self.texts.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) && t.type = 'Binda::Text' }
			raise ArgumentError, "There isn't any text associated to the current slug.", caller if obj.nil?
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
			obj = self.strings.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) && t.type = 'Binda::String' }
			unless obj.nil?
				obj.content
			else
				you_mean_text = !self.strings.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) && t.type = 'Binda::Text' }.nil?
				if you_mean_text
					raise ArgumentError, "This slug is associated to a text not a string. Use get_text() instead.", caller
				else
					raise ArgumentError, "There isn't any string associated to the current slug.", caller
				end
			end
		end

		# Get the object related to that field setting
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [boolean]
		def has_string field_slug 
			obj = self.strings.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) && t.type = 'Binda::String' }
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
			raise ArgumentError, "There isn't any image associated to the current slug.", caller if obj.nil?
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
			raise ArgumentError, "There isn't any image associated to the current slug.", caller if obj.nil?
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
			raise ArgumentError, "There isn't any date associated to the current slug.", caller if obj.nil?
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
			raise ArgumentError, "There isn't any date associated to the current slug.", caller if obj.nil?
			obj.date
		end

		# Check if exists any repeater with that slug
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [boolean]
		def has_repeater field_slug 
			obj = self.repeaters.find_all{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			raise ArgumentError, "There isn't any repeater associated to the current slug.", caller if obj.nil?
			return obj.present?
		end

		# Get the all repeater instances
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [hash]
		def get_repeater field_slug 
			obj = self.repeaters.find_all{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			raise ArgumentError, "There isn't any repeater associated to the current slug.", caller if obj.nil?
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
			obj = self.radios.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			raise ArgumentError, "There isn't any radio associated to the current slug.", caller if obj.nil?
			return { label: obj.choices.first.label, value: obj.choices.first.value }
		end

		# Get the select choices
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [hash] A hash of containing the label and value of the selected choice. `{ label: 'the label', 'value': 'the value'}`
		def get_selection_choice field_slug
			obj = self.selections.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			raise ArgumentError, "There isn't any radio associated to the current slug.", caller if obj.nil?
			return { label: obj.choices.first.label, value: obj.choices.first.value }
		end

		# Get the checkbox choice
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [array] An array of labels and values of the selected choices. `[{ label: '1st label', value: '1st-value'}, { label: '2nd label', value: '2nd-value'}]`
		def get_checkbox_choices field_slug
			obj = self.checkboxes.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			raise ArgumentError, "There isn't any checkbox associated to the current slug.", caller if obj.nil?
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
			obj = self.related_fields.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			raise ArgumentError, "There isn't any related field associated to the current slug.", caller if obj.nil?
			return obj.passive_relationships.any?
		end

		# Get related components
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [array] An array of components
		def get_related_components field_slug
			obj = self.related_fields.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			raise ArgumentError, "There isn't any related field associated to the current slug.", caller if obj.nil?
			return obj.passive_relationships.map{|relationship| relationship.dependent}
		end

		# Check if has related boards
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [boolean]
		# def has_related_boards field_slug
		# 	obj = self.related_fields.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
		# 	raise ArgumentError, "There isn't any related field associated to the current slug.", caller if obj.nil?
		# 	return obj.dependents.any?
		# end

		# Get related boards
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [array] An array of boards
		# def get_related_boards field_slug
		# 	obj = self.related_fields.find{ |t| t.field_setting_idid == FieldSetting.get_id( field_slug ) }
		# 	raise ArgumentError, "There isn't any related field associated to the current slug.", caller if obj.nil?
		# 	return obj.dependents
		# end

		# Find or create a field by field setting and field type
		# This is used in Binda's editor views
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
					return self.send( field_type.pluralize ).create!( field_setting_id: field_setting.id ) 
				else
					return obj
				end
			else
				raise ArgumentError, "One parameter in find_or_create_a_field_by() is not correct.", caller
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
    # WARNING when updating the order in components sort index, find_or_create_by generates several useless queries that slows down the CMS way too much!!!
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

	end
end