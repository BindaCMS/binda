module Binda
	class FieldSetting < ApplicationRecord
		cattr_accessor :field_settings_array
		cattr_accessor :get_field_classes

    # An array of all classes which represent fields associated to Binda::FieldSetting
    # This definition must stay on the top of the file
		def self.get_field_classes
			%w( String Text Date Image Video Repeater Radio Selection Checkbox Relation )
		end

		# ASSOCIATIONS
		# ------------

		belongs_to :field_group
		has_ancestry orphan_strategy: :destroy

		# FIELDS ASSOCIATIONS
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

		has_many :choices,        dependent: :delete_all # we don't want to run callbacks for choices!
		has_one  :default_choice, -> (field_setting) { where(id: field_setting.default_choice_id) }, class_name: 'Binda::Choice'
		
		has_and_belongs_to_many :accepted_structures, class_name: 'Binda::Structure'

		accepts_nested_attributes_for :accepted_structures, :texts, :strings, :dates, :galleries,
		                              :assets, :images, :videos, :repeaters, :radios, :selections,
		                              :checkboxes, :relations, :choices, allow_destroy: true, reject_if: :is_rejected

		# Sets the validation rules to accept and save an attribute
		def is_rejected( attributes )
			attributes['label'].blank? || attributes['content'].blank?
		end



		# CALLBACKS
		# ---------

    after_create do 
    	self.class.reset_field_settings_array
    	set_allow_null
    	create_field_instances
    end

    after_update do
			if %w(radio selection checkbox).include?(self.field_type) && self.choices.empty?
				check_allow_null_option
			end
    end

    after_destroy do 
    	self.class.reset_field_settings_array 
    end



    # VALIDATIONS
    # -----------

		validates :name, presence: { 
			message: I18n.t("binda.field_setting.validation_message.name") 
		}
		validates :field_type, inclusion: { 
			in: [ *FieldSetting.get_field_classes.map{ |fc| fc.to_s.underscore } ], 
			allow_nil: false, 
			message: I18n.t(
				"binda.field_setting.validation_message.field_type", 
				{ arg1: "#{FieldSetting.get_field_classes.join(", ")}" }
			)
		}
		validates :field_group_id, presence: {
			message: I18n.t("binda.field_setting.validation_message.field_group_id", { arg1: "%{value}" })
		}
		validate :slug_uniqueness
		validates :allow_null, 
			inclusion: { in: [false], message: "%{value} canont be true on a radio setting" }, 
			if: Proc.new { |a| a.field_type == 'radio' }



    # FRIENDLY ID
    # -----------

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
		end

		# Check slug uniqueness
		def slug_uniqueness
			record_with_same_slug = self.class.where(slug: slug)
			if record_with_same_slug.any? && !record_with_same_slug.ids.include?(id)
				errors.add(:slug, I18n.t("binda.field_setting.validation_message.slug", { arg1: slug })) 
			end
		end



		# MISCELLANEOUS
		# -------------

		# Retrieve the ID if a slug is provided and update the field_settings_array 
		#   in order to avoid calling the database (or the cached response) every time.
		#   This should speed up requests and make Rails logs are cleaner.
		# 
		# @return [integer] The ID of the field setting
		def self.get_id(field_slug)
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
		#   (This isn't done with a database constraint in order to gain flexibility)
		# 
		# REVIEW: not sure what flexibility is needed. Maybe should be done differently
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
			field_setting_id = self.id
			case 
				when structure.components.any?
					structure.components.each do |component|
						create_field_instances_for_component(component, field_class, field_setting_id)
					end
				when structure.board.present?
					create_field_instances_for_board(structure.board, field_class, field_setting_id)
			end
		end

		# Helper for create_field_instances method
		def create_field_instances_for_component(component, field_class, field_setting_id)
			unless component.send(field_class).where(field_setting_id: field_setting_id).any?
				component.send(field_class).create!(field_setting_id: field_setting_id)
			end
		end

		# Helper for create_field_instances method
		def create_field_instances_for_board(board, field_class, field_setting_id)
			unless board.send(field_class).where(field_setting_id: field_setting_id).any?
				board.send(field_class).create!(field_setting_id: field_setting_id)
			end
		end

		# Check `allow_null` option
		# 
		# Creating a selection with `allow_null` set to `false` will automatically generate a critical error.
		#   This is due to the fact that 1) there is no choice to select, but 2) the selection field must have at least one.
		#   The error can be easily removed by assigning a choice to the current field setting.
		# 
		# This method is preferred to a validation because it allows to remove all choices before adding new ones.
		#   
		def check_allow_null_option
    	# TODO: check if allow_null has been set to false -> if it is 
    	# you want to check that all Binda::Selection objects
    	# related to it have at least one choice -> if some don't
    	# have any choice, throw a warning and set a critical error 
    	# banner on the views related to those Binda::Selection objects
    	return if self.allow_null?

  		Selection.check_all_selections_depending_on(self)
			warn("WARNING: Binda::FieldSetting \"#{self.slug}\" must have at least one choice.")
		end

	end
end
