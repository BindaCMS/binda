module Binda
  class Repeater < ApplicationRecord

    include FieldableAssociations

  	# Associations
  	belongs_to :fieldable, polymorphic: true
    belongs_to :field_setting

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
