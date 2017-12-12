module Binda
	module ComponentsHelper

		# Get the sort index link
		#
		# This helper generate the a link to the page where to sort components, or 
		#   a broken link that tells you that you have too many components to go to that page.
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
		def prepare_description_for_form_hint field_setting
			if field_setting.description.blank?
				return false
			else 
				return field_setting.description
			end
		end

	end
end
