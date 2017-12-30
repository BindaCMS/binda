module Binda
	class FieldSetting < ApplicationRecord

		belongs_to :field_group
		has_ancestry orphan_strategy: :destroy

		# Is this reallly needed? Or can we just use accepted_structures? 
		# has_and_belongs_to_many :structures

		# Fields Associations
		# 
		# If you add a new field remember to update:
		#   - get_field_classes (see here below)
		#   - component_params (app/controllers/binda/components_controller.rb)
		has_many :texts,         as: :fieldable
		has_many :strings,       as: :fieldable
		has_many :dates,         as: :fieldable
		has_many :galleries,     as: :fieldable
		has_many :assets,        as: :fieldable
		has_many :images,        as: :fieldable
		has_many :videos,        as: :fieldable
		has_many :repeaters,     as: :fieldable
		has_many :radios,        as: :fieldable
		has_many :selections,    as: :fieldable
		has_many :checkboxes,    as: :fieldable
		has_many :relations,     as: :fieldable

		# The following direct associations are used to securely delete associated fields
		# Infact via `fieldable` the associated fields might not be deleted 
		# as the fieldable_id is related to the `component`, `board` or `repeater` rather than `field_setting`
		has_many :texts,          dependent: :destroy
		has_many :strings,        dependent: :destroy
		has_many :dates,          dependent: :destroy
		has_many :galleries,      dependent: :destroy
		has_many :repeaters,      dependent: :destroy
		has_many :radios,         dependent: :destroy
		has_many :selections,     dependent: :destroy
		has_many :checkboxes,     dependent: :destroy
		has_many :relations,      dependent: :destroy

		has_many :choices,        dependent: :destroy
		has_one  :default_choice, -> (field_setting) { where(id: field_setting.default_choice_id) }, class_name: 'Binda::Choice'
		
		has_and_belongs_to_many :accepted_structures, class_name: 'Binda::Structure'

		accepts_nested_attributes_for :accepted_structures, :texts, :strings, :dates, :galleries,
		                              :assets, :images, :videos, :repeaters, :radios, :selections,
		                              :checkboxes, :relations, :choices, allow_destroy: true, reject_if: :is_rejected

		# Sets the validation rules to accept and save an attribute
		def is_rejected( attributes )
			attributes['label'].blank? || attributes['content'].blank?
		end

		cattr_accessor :field_settings_array

    after_create do 
    	self.class.reset_field_settings_array 
    	set_allow_null
    	create_field_instances
    end

    after_destroy do 
    	self.class.reset_field_settings_array 
    end

		def self.get_field_classes
			%w( String Text Date Image Video Repeater Radio Selection Checkbox Relation )
		end

		# Validations
		validates :name, presence: true
		validates :field_type, inclusion: { in: [ *FieldSetting.get_field_classes.map{ |fc| fc.to_s.underscore } ], allow_nil: false, message: "Select field type among these: #{ FieldSetting.get_field_classes.join(", ") }" }
		validates :field_group_id, presence: true

		# Slug
		extend FriendlyId
		friendly_id :default_slug, use: [:slugged, :finders]


		# Friendly id preference on slug generation
		#
		# Method inherited from friendly id 
		# @see https://github.com/norman/friendly_id/issues/436
	  def should_generate_new_friendly_id?
	    slug.blank?
	  end

		# Set slug name
		#
		# It generates 4 possible slugs before falling back to FriendlyId default behaviour
		def default_slug
			slug = ''
			slug << self.field_group.structure.name
			slug << '-'
			slug << self.field_group.name
			unless self.parent.nil?
				slug << '-' 
				slug << self.parent.name 
			end
			
			possible_names = [ 
				"#{ slug }--#{ self.name }",
				"#{ slug }--#{ self.name }-1",
				"#{ slug }--#{ self.name }-2",
				"#{ slug }--#{ self.name }-3"
			]

			return possible_names
		end

		# Retrieve the ID if a slug is provided and update the field_settings_array 
		#   in order to avoid calling the database (or the cached response) every time.
		#   This should speed up requests and make Rails logs are cleaner.
		# 
		# @return [integer] The ID of the field setting
		def self.get_id( field_slug )
			# Get field setting id from slug, without multiple calls to database 
			# (the query runs once and caches the result, then any further call uses the cached result)
			@@field_settings_array = self.pluck(:slug, :id) if @@field_settings_array.nil?
			selected_field_setting = @@field_settings_array.select{ |fs| fs[0] == field_slug }[0]
			raise ArgumentError, "There isn't any field setting with the current slug.", caller if selected_field_setting.nil?
			id = selected_field_setting[1]
			return id
		end

		# Reset the field_settings_array. It's called every time 
		#   the user creates or destroyes a Binda::FieldSetting
		# 
		# @return [null]
		def self.reset_field_settings_array
			# Reset the result of the query taken with the above method,
			# this is needed when a user creates a new field_setting but 
			# `get_field_setting_id` has already run once
			@@field_settings_array = nil
		end

		# Make sure that allow_null is set to false instead of nil.
		#   This isn't done with a database constraint in order to gain flexibility
		def set_allow_null
			self.allow_null = false if self.allow_null.nil?
		end

		# Generates a default field instances for each existing component or board
		#   which is associated to that field setting. This avoid having issues 
		#   with Binda::FieldSetting.get_id method which would throw an ambiguous error 
		#   saying that there isn't any field setting associated when infact it's 
		#   the actual field missing, not the field setting itself.
		#   
		# A similar script runs after saving components and boards which makes sure
		#   a field instance is always present no matter if the component has been created
		#   before the field setting or the other way around.
		def create_field_instances
			structure = self.field_group.structure
			field_class = self.field_type.pluralize
			case 
				when structure.components.any?
					structure.components.each do |component|
						unless component.send(field_class).where(field_setting_id: self.id).any?
							component.send(field_class).create!(field_setting_id: self.id)
						end
					end
				when structure.board.present?
					unless structure.board.send(field_class).where(field_setting_id: self.id).any?
						structure.board.send(field_class).create!(field_setting_id: self.id)
					end
			end
		end

	end
end
