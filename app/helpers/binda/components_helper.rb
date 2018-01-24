module Binda
	module ComponentsHelper

		# Get the sort index link
		#
		# This helper generate the a link to the page where to sort components, or 
		#   a broken link that tells you that you have too many components to go to that page.
		#   
		def get_sort_index_link
			if @structure.components.length < Component.sort_limit
				link_to "<i class=\"fa fa-random\" aria-hidden=\"true\"></i>Sort #{ @structure.name.humanize.split.map(&:capitalize).join(' ').pluralize }".html_safe, structure_components_sort_index_path, class: 'main-header--link b-btn b-btn-primary'
			else
				link_to "Sort #{ @structure.name.humanize.split.map(&:capitalize).join(' ').pluralize }", '#', class: 'main-header--link b-btn b-btn-primary', onclick: "alert(\"Sorry! It's not possible to sort #{@structure.name.pluralize} anymore. You currently have more than #{Component.sort_limit} #{@structure.name.pluralize} which is the maximum limit.\")"
			end
		end

		# Prepare description for form hint
		# 
		# This helper return the field description (as `string`) or false (as `boolean`)
		#   in order to tell Simple Form whether to generate or not the hint html tag.
		#   
		def prepare_description_for_form_hint field_setting
			if field_setting.description.blank?
				return false
			else 
				return field_setting.description
			end
		end

		# Get sort link by argument
		#
		# This method returns a URL which contains the current sort options
		#   and update just the title one. The URL then is used to change the 
		#   sorting of the index in which is used.
		#  
		# Rails guide reference --> http://guides.rubyonrails.org/action_controller_overview.html#hash-and-array-parameters
		# 
		# @param arg [string] This should be the database column on which sort will be based
		# @return [string] The URL with the encoded parameters
		# 
    def get_sort_link_by arg
      if params[:order].nil? 
      	structure_components_path( [@structure], { order: {"#{arg}": "DESC"} } )
      else
      	order_hash = params[:order].permit(:name, :publish_state).to_h
      	if order_hash[arg] == "ASC"
	        order_hash[arg] = "DESC"
	        structure_components_path( [@structure], { order: order_hash }  )
	      else
	      	order_hash[arg] = "ASC"
	        structure_components_path( [@structure], { order: order_hash }  )
	      end
	    end
    end

		# Get sort link icon by argument
		#
		# This method returns a Font Awesome icon 
		# 
		# @param arg [string] This should be the database column on which sort will be based
		# @return [string] The icon which needs to be escaped with the `html_safe` method
		# 
    def get_sort_link_icon_by arg
    	case 
    	when params[:order].nil?
        '<i class="fas fa-sort-alpha-down"></i>'
    	when params[:order][arg] == "DESC"
        '<i class="fas fa-sort-alpha-up"></i>'
    	else
        '<i class="fas fa-sort-alpha-down"></i>'
    	end
    end

	end
end
