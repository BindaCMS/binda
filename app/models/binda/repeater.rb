module Binda
  class Repeater < ApplicationRecord

  	# Associations
  	belongs_to :fieldable, polymorphic: true
    belongs_to :field_setting
  	# has_many :field_settings, dependent: :delete_all

    # Fields Associations 
    # -------------------
    # If you add a new field remember to update:
    #   - get_fieldables (see here below)
    #   - get_field_types (see here below)
    #   - component_params (app/controllers/binda/components_controller.rb)
    has_many :texts,         as: :fieldable, dependent: :delete_all
    has_many :dates,         as: :fieldable, dependent: :delete_all
    has_many :repeaters,     as: :fieldable, dependent: :delete_all
    has_many :galleries,     as: :fieldable, dependent: :delete_all
    has_many :assets,        as: :fieldable, dependent: :delete_all
    
    accepts_nested_attributes_for :texts, :dates, :assets, :galleries, :repeaters, allow_destroy: true

    # The following direct association is used to securely delete associated fields
    # Infact via `fieldable` the associated fields might not be deleted 
    # as the fieldable_id is related to the `component` rather than the `field_setting`

    # # Validations
    # validates :name, presence: true

    # # Slug
    # extend FriendlyId
    # friendly_id :default_slug, use: [:slugged, :finders]

    def find_or_create_a_field_by field_setting_id, field_type
      if Binda::FieldSetting.get_fieldables.include?( field_type.capitalize ) && field_setting_id.is_a?( Integer )
        self.send( field_type.pluralize ).find_or_create_by( field_setting_id: field_setting_id )
      else
        raise ArgumentError, "A parameter of the method 'find_or_create_a_field_by' is not correct.", caller
      end
    end

  end
end
