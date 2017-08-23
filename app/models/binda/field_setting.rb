module Binda
	class FieldSetting < ApplicationRecord

		# Associations
		belongs_to :field_group
		has_ancestry orphan_strategy: :destroy

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
		has_many :repeater,      as: :fieldable
		has_many :radio,         as: :fieldable
		has_many :selection,     as: :fieldable
		has_many :checkbox,      as: :fieldable


		# The following direct association is used to securely delete associated fields
		# Infact via `fieldable` the associated fields might not be deleted 
		# as the fieldable_id is related to the `component`, `board` or `repeater` rather than `field_setting`
		has_many :texts,         dependent: :delete_all
		has_many :strings,       dependent: :delete_all
		has_many :dates,         dependent: :delete_all
		has_many :galleries,     dependent: :delete_all
		has_many :repeater,      dependent: :delete_all
		has_many :radio,         dependent: :delete_all
		has_many :selection,     dependent: :delete_all
		has_many :checkbox,      dependent: :delete_all

		has_many :choices,       dependent: :delete_all
		has_one  :default_choice, -> (field_setting) { where(id: field_setting.default_choice_id) }, class_name: 'Binda::Choice'

		accepts_nested_attributes_for :choices, allow_destroy: true, reject_if: :is_rejected


		#
		# Sets the validation rules to accept and save an attribute
		def is_rejected( attributes )
			attributes['label'].blank? || attributes['content'].blank?
		end

		cattr_accessor :field_settings_array

		after_create :set_allow_null

    after_create do 
    	self.class.reset_field_settings_array 
    end

    after_destroy do 
    	self.class.reset_field_settings_array 
    end

		def self.get_field_classes
			%w( String Text Date Asset Repeater Radio Selection Checkbox )
		end

		# Validations
		validates :name, presence: true
		validates :field_type, inclusion: { in: FieldSetting.get_field_classes.map{ |fc| fc.to_s.underscore } } #presence: true
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
		#   This way Rails logs are much cleaner
		# 
		# @return [integer] The ID of the field setting
		def self.get_id( field_slug )
			# Get field setting id from slug, without multiple calls to database 
			# (the query runs once and caches the result, then any further call uses the cached result)
			@@field_settings_array = self.all if @@field_settings_array.nil?
			obj = @@field_settings_array.find { |fs| fs.slug == field_slug }
			if obj.nil?
				raise ArgumentError, "There isn't any field setting with the current slug.", caller
			else
				obj.id
			end
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

	end
end
