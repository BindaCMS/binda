module Binda
	# Fieldable associations are Binda's core feature. 
	# 
	# They provide model classes like `Binda::Component` and `Binda::Board` with a collection of fields 
	#   (texts, assets, dates and so on) to store data in a simple yet powerful way. It's possible to 
	#   make use of a set of helpers to retrieve fields data belonging to each model instance. 
	module FieldableAssociations

		extend ActiveSupport::Concern

		included do 

	    include FieldableAssociationHelpers
	    
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

		# Find or create a field by field setting and field type
		# 
		# This is used in Binda's editor views.
		#   
		# Please, check the code to know more about the way this method works as it's pretty complex yet important.
		# 
		# @param field_setting_id [string] The field setting id
		# @param field_type [string] THe field type
		def find_or_create_a_field_by(field_setting_id, field_type)
			if FieldSetting.get_field_classes.include?( field_type.classify ) && field_setting_id.is_a?( Integer )
				get_field(field_type, field_setting_id)
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

		private

			# Get field based on field type and field setting
			# @param field_type [string]
			# @param field_setting_id [integer]
			# @return [ActiveRecord]
			def get_field(field_type, field_setting_id)
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
			end
	end
end