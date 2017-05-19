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
    has_many :galleries,     as: :fieldable, dependent: :delete_all
    has_many :assets,        as: :fieldable, dependent: :delete_all
    # Repeaters need destroy_all, not delete_all
    has_many :repeaters,     as: :fieldable, dependent: :destroy

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

    def get_text( field_slug )
      # Get the object related to that field setting
      self.texts.find{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }.content
    end

    def has_text( field_slug )
      # Get the object related to that field setting
      obj = self.texts.find{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }
      if obj.present?
        !obj.content.blank?
      else
        return false
      end
    end

    def has_image( field_slug )
      # Check if the field has an attached image
      self.assets.find{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }.image.present?
    end

    def get_image_url( field_slug, size = '' )
      get_image_info( field_slug, size, 'url' )
    end

    def get_image_path( field_slug, size = '' )
      get_image_info( field_slug, size, 'path' )
    end

    def get_image_info( field_slug, size, info )
      # Get the object related to that field setting
      obj = self.assets.find{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }
      if obj.image.present?
        if obj.image.respond_to?(size) && %w[thumb medium large].include?(size)
          obj.image.send(size).send(info)
        else
          obj.image.send(info)
        end
      end
    end

    def has_date( field_slug )
      # Check if the field has an attached date
      obj = self.dates.find{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }
      if obj.present?
        !obj.date.nil?
      else
        return false
      end
    end

    def get_date( field_slug )
      # Get the object related to that field setting
      self.dates.find{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }.date
    end


    def has_repeater( field_slug )
      obj = self.repeaters.find_all{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }
      return obj.present?
    end

    def get_repeater( field_slug )
      self.repeaters.find_all{ |t| t.field_setting_id == Binda::FieldSetting.get_id( field_slug ) }.sort_by(&:position)
    end

  end
end
