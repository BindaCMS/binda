module Binda
  class Repeater < ApplicationRecord

    include ComponentModelHelper

  	# Associations
  	belongs_to :fieldable, polymorphic: true
    belongs_to :field_setting

    # Fields Associations 
    # 
    # If you add a new field remember to update:
    #   - get_fieldables (see here below)
    #   - get_field_types (see here below)
    #   - component_params (app/controllers/binda/components_controller.rb)
    has_many :texts,         as: :fieldable, dependent: :delete_all
    has_many :dates,         as: :fieldable, dependent: :delete_all
    has_many :galleries,     as: :fieldable, dependent: :delete_all
    has_many :assets,        as: :fieldable, dependent: :delete_all
    has_many :radios,        as: :fieldable, dependent: :delete_all 
    has_many :selects,       as: :fieldable, dependent: :delete_all 
    has_many :checkboxes,    as: :fieldable, dependent: :delete_all 
    # Repeaters need destroy_all, not delete_all
    has_many :repeaters,     as: :fieldable, dependent: :destroy

    accepts_nested_attributes_for :texts, :dates, :assets, :galleries, :repeaters, :radios, :selects, :checkboxes, allow_destroy: true

    # The following direct association is used to securely delete associated fields
    # Infact via `fieldable` the associated fields might not be deleted 
    # as the fieldable_id is related to the `component` rather than the `field_setting`

    after_create :set_default_position

    def set_default_position
        position = self.fieldable.repeaters.find_all{ |r| r.field_setting_id == self.field_setting.id }.length
        self.update_attribute 'position', position
    end

  end
end
