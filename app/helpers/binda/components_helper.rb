module Binda
  module ComponentsHelper

  	def get_form_component_url
  		return structure_components_path if action_name == 'new'
  		return structure_component_path  if action_name == 'edit'
  	end

  end
end
