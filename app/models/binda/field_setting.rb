module Binda
	class FieldSetting < ApplicationRecord
		cattr_accessor :field_settings_array
		cattr_accessor :get_field_classes

    # An array of all classes which represent fields associated to Binda::FieldSetting
    # This definition must stay on the top of the file
		def self.get_field_classes
			%w( String Text Date Image Video Audio Repeater Radio Selection Checkbox Relation )
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
		has_many :audios,        as: :fieldable
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
		has_many :assets,         dependent: :destroy
		has_many :images,         dependent: :destroy
		has_many :videos,         dependent: :destroy
		has_many :audios,         dependent: :destroy

		# We don't want to run callbacks for choices!
		# If you run a callback the last choice will throw a error
		# @see `Binda::Choice` `before_destroy :check_last_choice`
		has_many :choices,        dependent: :delete_all 

		has_one  :default_choice, -> (field_setting) { where(id: field_setting.default_choice_id) }, class_name: 'Binda::Choice'
		
		has_and_belongs_to_many :accepted_structures, class_name: 'Binda::Structure'

		accepts_nested_attributes_for :accepted_structures, :texts, :strings, :dates, :galleries,
		                              :assets, :images, :videos, :audios, :repeaters, :radios, :selections,
		                              :checkboxes, :relations, :choices, allow_destroy: true, reject_if: :is_rejected

		# Sets the validation rules to accept and save an attribute
		def is_rejected( attributes )
			attributes['label'].blank? || attributes['content'].blank?
		end



		# CALLBACKS
		# ---------

		before_save do
			check_allow_null_for_radio
		end

		after_save do
			add_choice_if_allow_null_is_false
		end

    after_create do 
    	self.class.reset_field_settings_array
    	convert_allow_null__nil_to_false
    	create_field_instances
    	set_default_position
    end

    after_update do
			self.class.remove_orphan_fields
			if %w(radio selection checkbox).include?(self.field_type) && self.choices.empty?
				check_allow_null_option
			end
    end

    after_destroy do 
    	self.class.reset_field_settings_array 
    end



    # VALIDATIONS
    # -----------
    # @see http://guides.rubyonrails.org/active_record_validations.html#message

		validates :name, presence: { 
			message: I18n.t("binda.field_setting.validation_message.name") 
		}
		validates :field_type, inclusion: { 
			in: [ *FieldSetting.get_field_classes.map{ |fc| fc.to_s.underscore } ], 
			allow_nil: false,
			message: -> (field_setting, _) { 
				I18n.t(
					"binda.field_setting.validation_message.field_type", 
					{ arg1: field_setting.name, arg2: FieldSetting.get_field_classes.join(", ") }
				)
			}
		}
		validates :field_group_id, presence: {
			message: -> (field_setting, data) {
				I18n.t(
					"binda.field_setting.validation_messag e.field_group_id", 
					{ arg1: field_setting.name, arg2: data[:value] }
				)
			}
		}
		validate :slug_uniqueness


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
			return self.name if self.field_group_id.nil?
			slug = ''
			slug << self.field_group.structure.name
			slug << '-'
			slug << self.field_group.name
			unless self.parent.nil?
				slug << '-' 
				slug << self.parent.name 
			end
			return [ 
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
				return false
			else
				return true 
			end
		end

		# It makes sure radio buttons have allow_null set to false.
		def check_allow_null_for_radio
			if field_type == 'radio' && allow_null?
				self.allow_null = false
				warn "WARNING: it's not possible that a field setting with type `radio` has allow_null=true."
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
			raise ArgumentError, "There isn't any field setting with the current slug \"#{field_slug}\".", caller if selected_field_setting.nil?
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
		def convert_allow_null__nil_to_false
			self.allow_null = false if self.allow_null.nil?
		end

		# Get structure on which the current field setting is attached. It should be one, but in order to 
		#   be able to add other methods to the query this methods returns a `ActiveRecord::Relation` object, not
		#   a `ActiveRecord`
		# 
		# @return [ActiveRecord::Relation] An array of `Binda::Structure` instances
		def structures
			Structure.left_outer_joins(
				field_groups: [:field_settings]
			).where(
				binda_field_settings: { id: self.id }
			)
		end

		# Get the structure of the field group to which the field setting belongs.
		# 
		# @return [ActiveRecord] The `Binda::Structure` instance
		def structure
			self.structures.first
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
			# Get the structure
			structure = self.structures.includes(:board, components: [:repeaters]).first
			structure.components.each do |component|
				create_field_instance_for(component)
			end
			create_field_instance_for(structure.board) if structure.board.present?
		end

		def create_field_instance_for(instance)
			field_class = "Binda::#{self.field_type.classify}"
			if self.is_root?
				create_field_instance_for_instance(instance, field_class, self.id)
			else
				instance.repeaters.select{|r| r.field_setting_id == self.parent_id}.each do |repeater|
					create_field_instance_for_instance(repeater, field_class, self.id)
				end
			end
		end

		# Helper for create_field_instances method
		def create_field_instance_for_instance(instance, field_class, field_setting_id)
			field_class.constantize.find_or_create_by!(
				field_setting_id: field_setting_id,
				fieldable_id: instance.id,
				fieldable_type: instance.class.name
			)
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
    	return if self.allow_null?
  		Selection.check_all_selections_depending_on(self)
		end

		# Validation method that check if the current `Binda::Selection` instance has at least a choice before 
		#   updating allow null to false
		def add_choice_if_allow_null_is_false
			if %(selection radio checkbox).include?(self.field_type) && 
				!self.allow_null?
				if self.choices.empty?
					# Add a choice if there is none, it will be automatically assign as default choice
					self.choices.create!(label: I18n.t("binda.choice.default_label"), value: I18n.t("binda.choice.default_value"))
				elsif self.default_choice_id.nil?
					# Assign a choice as default one if there is any
					# REVIEW there is some deprecation going on, but I'm not sure i directly involves the `update` method
					self.update!(default_choice_id: self.choices.first.id)
				end
			end
		end

		# Remove all orphan fields
		# 
		# Specifically:
		# - all fields where their field setting doesn't exist anymore
		# - all fields where their field setting has change type
		# 
		# Used by task `rails binda:remove_orphan_fields`
		def self.remove_orphan_fields
			FieldSetting.get_field_classes.each do |field_class|
				FieldSetting.remove_orphan_fields_with_no_settings(field_class)
				FieldSetting.remove_orphan_fields_with_wrong_field_type(field_class)
			end
		end

		# Remove orphan fields that isn't associated to any field setting
		def self.remove_orphan_fields_with_no_settings(field_class)
			"Binda::#{field_class}"
				.constantize
				.includes(:field_setting)
				.where(binda_field_settings: {id: nil})
				.each do |s| 
					s.destroy!
					puts "Binda::#{field_class} with id ##{s.id} successfully destroyed"
				end
		end

		# Remove orphan fields with wrong field type
		def self.remove_orphan_fields_with_wrong_field_type(field_class)
			field_types = []
			case field_class
			when 'Selection'
				field_types = %w(selection checkbox radio)
			when 'Text'
				field_types = %w(string text)
			else
				field_types = [ field_class.underscore ]
			end
			"Binda::#{field_class}"
				.constantize
				.includes(:field_setting)
				.where.not(binda_field_settings: {field_type: field_types})
				.each do |s| 
					s.destroy!
					puts "Binda::#{field_class} with id ##{s.id} but wrong type successfully destroyed"
				end
		end

		# Set a default position if isn't set and updates all related field settings
		# Update all field settings related to the one created
		def set_default_position
			FieldSetting
				.where(
					field_group_id: self.field_group_id,
					ancestry: self.ancestry
				)
				.each{|field_setting| field_setting.increment(:position).save!}
		end

	end
end
