module Binda
	class FieldSetting < ApplicationRecord

		# Associations
		belongs_to :field_group
		# has_many   :field_children, class_name: ::Binda::FieldSetting, dependent: :delete_all
		has_ancestry orphan_strategy: :destroy

		# Fields Associations
		# -------------------
		# If you add a new field remember to update:
		#   - get_fieldables (see here below)
		#   - get_field_types (see here below)
		#   - component_params (app/controllers/binda/components_controller.rb)
		has_many :texts,         as: :fieldable
		has_many :dates,         as: :fieldable
		has_many :galleries,     as: :fieldable
		has_many :assets,        as: :fieldable
		has_many :repeater,      as: :fieldable
		has_many :radio,         as: :fieldable
		has_many :select,        as: :fieldable
		has_many :checkbox,      as: :fieldable
		has_many :truefalse,     as: :fieldable


		# The following direct association is used to securely delete associated fields
		# Infact via `fieldable` the associated fields might not be deleted 
		# as the fieldable_id is related to the `component` rather than the `field_setting`
		has_many :texts,         dependent: :delete_all
		has_many :dates,         dependent: :delete_all
		has_many :galleries,     dependent: :delete_all
		has_many :repeater,      dependent: :delete_all
		has_many :radio,         dependent: :delete_all
		has_many :select,        dependent: :delete_all
		has_many :checkbox,      dependent: :delete_all
		has_many :truefalse,     dependent: :delete_all

		# accepts_nested_attributes_for :children, allow_destroy: true, reject_if: :is_rejected

		cattr_accessor :field_settings_array

		def self.get_fieldables
			%w( Text Date Gallery Asset Repeater Radio Select Checkbox Truefalse )
		end

		# Field types are't fieldable! watch out! They might use the same model (eg `string` and `text`)
		def get_field_types
			%w( string text asset gallery repeater date radio select checkbox truefalse )
		end

		# Validations
		validates :name, presence: true
		# validates :field_type, presence: true, inclusion: { in: :get_field_types }
		validates :field_group_id, presence: true

		# Slug
		extend FriendlyId
		friendly_id :default_slug, use: [:slugged, :finders]


		# CUSTOM METHODS
		# --------------
		# https://github.com/norman/friendly_id/issues/436
		def should_generate_new_friendly_id?
			slug.blank?
		end

		def default_slug
			slug = self.field_group.structure.name
			
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

		def self.get_id( field_slug )
			# Get field setting id from slug, without multiple calls to database 
			# (the query runs once and caches the result, then any further call uses the cached result)
			@@field_settings_array = self.all if @@field_settings_array.nil?
			@@field_settings_array.find { |fs| fs.slug == field_slug }.id
		end

		def self.reset_field_settings_array
			# Reset the result of the query taken with the above method,
			# this is needed when a user creates a new field_setting but 
			# `get_field_setting_id` has already run once
			@@field_settings_array = nil
		end

	end
end
