module Binda
  module CategoriesHelper

  	def get_form_category_url
  		return structure_categories_path if action_name == 'new'
  		return structure_category_path  if action_name == 'edit'
  	end

  end
end
