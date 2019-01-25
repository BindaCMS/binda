module Binda
  class GenerateFieldsJob < ApplicationJob
    queue_as :default

    def perform instance
      # If this is a component or a board
    	if instance.respond_to?('structure')
	    	field_settings = FieldSetting.where(field_group_id: FieldGroup.where(structure_id: instance.structure.id))
	    	field_settings.each do |field_setting|
	    		"Binda::#{field_setting.field_type.classify}".constantize.find_or_create_by!(
	    			fieldable_id: instance.id, fieldable_type: instance.class.name, field_setting_id: field_setting.id )
	    	end
    	# If this is a repeater
    	else
    		instance.field_setting.children.each do |field_setting|
	    		"Binda::#{field_setting.field_type.classify}".constantize.find_or_create_by!(
	    			fieldable_id: instance.id, fieldable_type: instance.class.name, field_setting_id: field_setting.id )
    		end
	    end
    end


  end
end
