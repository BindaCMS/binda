module Binda
  class Repeater < ApplicationRecord

    include FieldableAssociations
    include Fields

    # The following direct association is used to securely delete associated fields
    # Infact via `fieldable` the associated fields might not be deleted
    # as the fieldable_id is related to the `component` rather than the `field_setting`

    after_create :set_default_position

    # Set default position after create
    #
    # This methods ensure that every repeater instance has an explicit position.
    #   The latest repeater created gets the highest position number.
    #
    # @return [object] Repeater instance
    def set_default_position
        Repeater
            .where(
                field_setting_id: self.field_setting_id,
                fieldable_id: self.fieldable_id,
                fieldable_type: self.fieldable_type
            )
            .update_all('position = position + 1')
    end



  end
end
