module Binda
  class CreateFieldInstancesJob < ApplicationJob
    queue_as :default

    def perform( instance )
      instance_field_settings = FieldSetting
        .includes(field_group: [ :structure ])
        .where(binda_structures: { id: instance.structure.id })
      instance_field_settings.each do |field_setting|
        field_setting.create_field_instance_for( instance )
      end
    end
  end
end
