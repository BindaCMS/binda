module Binda
  class CreateFieldInstancesJob < ApplicationJob
    queue_as :default

    def perform( instance )
      instance_type = instance.class.name.demodulize.underscore
      send "perform_for_#{instance_type}", instance
    end

    private

    def perform_for_component component
      instance_field_settings = FieldSetting
        .includes(field_group: [ :structure ])
        .where(binda_structures: { id: component.structure.id })
      instance_field_settings.each do |field_setting|
        field_setting.create_field_instance_for( component )
      end

      component
    end
    alias_method :perform_for_board, :perform_for_component

    def perform_for_field_setting field_setting
      FieldSetting.remove_orphan_fields
			# Get the structure
			structure = field_setting.structures.includes(:board, components: [:repeaters]).first
			structure.components.each do |component|
				perform_for_component(component)
			end
			perform_for_component(structure.board) if structure.board.present?
    end
  end
end
