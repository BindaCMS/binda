module Binda
  class Repeater < ApplicationRecord

  	# Associations
  	belongs_to :fieldable, polymorphic: true
  	belongs_to :field_setting

    # Fields Associations 
    # -------------------
    # If you add a new field remember to update:
    #   - get_fieldables (see here below)
    #   - get_field_types (see here below)
    #   - component_params (app/controllers/binda/components_controller.rb)
    has_many :texts,         as: :fieldable
    has_many :dates,         as: :fieldable
    has_many :repeaters,     as: :fieldable
    has_many :galleries,     as: :fieldable
    has_many :assets,        as: :fieldable 
    # The following direct association is used to securely delete associated fields
    # Infact via `fieldable` the associated fields might not be deleted 
    # as the fieldable_id is related to the `component` rather than the `field_setting`
    has_many :texts,         dependent: :delete_all
    has_many :dates,         dependent: :delete_all
    has_many :repeaters,     dependent: :delete_all
    has_many :galleries,     dependent: :delete_all

    # Validations
    validates :name, presence: true

    # Slug
    extend FriendlyId
    friendly_id :default_slug, use: [:slugged, :finders]

  end
end
