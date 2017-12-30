module Binda
  module StructuresHelper

    def get_structures_sort_index_link

        link_to "<i class=\"fa fa-random\" aria-hidden=\"true\"></i>Sort Structures".html_safe, structures_sort_index_path, class: 'main-header--link b-btn b-btn-primary'
    end

  end
end
