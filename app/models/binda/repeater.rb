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

    # Set default position after create
    # 
    # This methods ensure that every repeater instance has an explicit position.
    #   The latest repeater created gets the highest position number.
    #   The first position is 1 (not 0).
    # 
    # @return [object] Repeater instance
    def set_default_position
        # apparently `self.fieldable != self.fieldable_type.constantize.find( self.fieldable_id )`
        # as the former has always one repeater, the latter has all repeaters created so far
        # that's way we use the longer version
        instance = self.fieldable_type.constantize.find( self.fieldable_id )
        position = instance.repeaters.find_all{ |r| r.field_setting_id == self.field_setting.id }.length
        self.update_attribute 'position', position
    end

  end
end
