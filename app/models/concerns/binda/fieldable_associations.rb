module Binda
	module FieldableAssociations
		# Fieldable associations are Binda's core feature. 
		# 
		# They provide model classes with a collection of fields (texts, assets, dates and so on)
		#   to store data in a simple yet powerful way. It's possible to make use of a set of helpers to 
		#   retrieve fields data belonging to each model instance. See the following methods. 

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
	    has_many :radios,        as: :fieldable, dependent: :delete_all 
	    has_many :selections,       as: :fieldable, dependent: :delete_all 
	    has_many :checkboxes,    as: :fieldable, dependent: :delete_all 
	    # Repeaters need destroy_all, not delete_all
	    has_many :repeaters,     as: :fieldable, dependent: :destroy

			# has_many :bindings
			# has_many :assets, class_name: 'Admin::Asset', through: :bindings

	    accepts_nested_attributes_for :texts, :strings, :dates, :assets, :galleries, :repeaters, :radios, :selections, :checkboxes, allow_destroy: true

	    # TODO not sure this is needed
			# cattr_accessor :field_settings_array
		end

		# Get the object related to that field setting
		# If the object doesn't exists yet it will return nil
		# 
		# @param  field_slug [string] The slug of the field setting
		# @return [string] Returns the content of the text 
		# @return [nil]    Returns null if it's empty or it doesn't exists
		def get_text field_slug 
			obj = self.texts.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			obj.content unless obj.nil?
		end

		# Get the object related to that field setting
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [boolean]
		def has_text field_slug 
			obj = self.texts.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
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
		# @return [nil]    Returns null if it's empty or it doesn't exists
		def get_string field_slug 
			obj = self.strings.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			obj.content unless obj.nil?
		end

		# Get the object related to that field setting
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [boolean]
		def has_string field_slug 
			obj = self.strings.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
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
			obj = self.assets.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }.image
			return obj.present?
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
			obj = self.assets.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
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
			obj.date unless obj.nil?
		end

		# Check if exists any repeater with that slug
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [boolean]
		def has_repeater field_slug 
			obj = self.repeaters.find_all{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			return obj.present?
		end

		# Get the all repeater instances
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [hash]
		def get_repeater field_slug 
			obj = self.repeaters.find_all{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			obj.sort_by(&:position) unless obj.nil?
		end

		# Get the radio choice
		# 
		# If by mistake the Radio instance has many choices associated, 
		#   only the first one will be retrieved.
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [hash] A hash of containing the label and value of the selected choice.
		def get_radio_choice field_slug
			obj = self.radios.find{ |t| t.field_setting_id == FieldSetting.get_id( field_slug ) }
			obj_hash = { label: obj.choices.first.label, value: obj.choices.first.value }
		end

		# Get the select choices
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [hash] A hash of containing the label and value of the selected choice.
		def get_selection_choice field_slug
			# select cannot be chosen has variable name, therefore is prefixed with 's'
			obj = self.selections.find{ |t| t.field_setting_id = FieldSetting.get_id( field_slug ) }
			obj_hash = { label: obj.choices.first.label, value: obj.choices.first.value }
		end

		# Get the checkbox choice
		# 
		# @param field_slug [string] The slug of the field setting
		# @return [hash] A hash of labels and values of the selected choices.
		def get_checkbox_choices field_slug
			obj = self.checkboxes.find{ |t| t.field_setting_id = FieldSetting.get_id( field_slug ) }
			obj_hash = {}
			obj.choices.order('label').each do |o|
				obj_hash << { label: obj.choices.first.label, value: obj.choices.first.value }
			end
			return obj_hash
		end

		# Find or create a field by field setting and field type
		# This is used in Binda's form
		# 
		# @param field_setting_id [string] The field setting id
		# @param field_type [string] THe field type
		def find_or_create_a_field_by field_setting_id, field_type
			if FieldSetting.get_fieldables.include?( field_type.capitalize ) && field_setting_id.is_a?( Integer )
				self.send( field_type.pluralize ).find_or_create_by( field_setting_id: field_setting_id )
			else
				raise ArgumentError, "One parameter of find_or_create_a_field_by() is not correct.", caller
			end
		end
	end
end