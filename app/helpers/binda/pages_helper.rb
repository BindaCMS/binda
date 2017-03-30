module Binda
  module PagesHelper

  	def get_form_page_url
  		return structure_pages_path if action_name == 'new'
  		return structure_page_path  if action_name == 'edit'
  	end

  end
end
