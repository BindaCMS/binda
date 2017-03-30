module Binda
  module FieldGroupsHelper

  	def get_form_field_group_url
  		return structure_field_groups_path if action_name == 'new'
  		return structure_field_group_path  if action_name == 'edit'
  	end

  end
end
