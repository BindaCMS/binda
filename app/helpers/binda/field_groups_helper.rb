module Binda
  module FieldGroupsHelper

    # Returns the right path for "new" or "edit" action
  	def get_form_field_group_url
  		return structure_field_groups_path if action_name == 'new'
  		return structure_field_group_path  if action_name == 'edit'
  	end

    # Get all components related to a "relation" field setting
  	def get_relationable_components(field_setting)
  		if @instance.class.to_s == 'Binda::Component'
	  		Component.where(structure_id: Structure.where(id: field_setting.accepted_structure_ids)).where.not(id: @instance.id)
	  	elsif @instance.class.to_s == 'Binda::Board' 
	  		Component.where(structure_id: Structure.where(id: field_setting.accepted_structure_ids))
	  	end
  	end

    # Get all boards related to a "relation" field setting
  	def get_relationable_boards(field_setting)
  		if @instance.class.to_s == 'Binda::Component'
	  		Board.where(structure_id: Structure.where(id: field_setting.accepted_structure_ids))
	  	elsif @instance.class.to_s == 'Binda::Board' 
	  		Board.where(structure_id: Structure.where(id: field_setting.accepted_structure_ids)).where.not(id: @instance.id)
	  	end
  	end

    # Retrieve the number of records present in the database for the current structure
    def get_entries_number
      instance_type = @structure.instance_type
      if ['board', 'component'].include? instance_type
        "Binda::#{instance_type.classify}".constantize.where(structure_id:@structure.id).count 
      else
        0
      end
    end

  end
end
