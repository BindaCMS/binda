module Binda
  module FieldGroupsHelper

  	def get_form_field_group_url
  		return structure_field_groups_path if action_name == 'new'
  		return structure_field_group_path  if action_name == 'edit'
  	end

  	def get_relationable_components field_setting
  		if @instance.class.to_s == 'Binda::Component'
	  		Binda::Component.where( structure_id: Binda::Structure.where( id: field_setting.accepted_structure_ids )).where.not(id: @instance.id)
	  	elsif @instance.class.to_s == 'Binda::Board' 
	  		Binda::Component.where( structure_id: Binda::Structure.where( id: field_setting.accepted_structure_ids ))
	  	end
  	end

  	def get_relationable_boards field_setting
  		if @instance.class.to_s == 'Binda::Component'
	  		Binda::Board.where( structure_id: Binda::Structure.where( id: field_setting.accepted_structure_ids ))
	  	elsif @instance.class.to_s == 'Binda::Board' 
	  		Binda::Board.where( structure_id: Binda::Structure.where( id: field_setting.accepted_structure_ids )).where.not(id: @instance.id)
	  	end
  	end

  end
end
