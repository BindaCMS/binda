module Binda
	module ComponentControllerHelper
		extend ActiveSupport::Concern

	  def get_components( slug, ask_for_published = true, custom_order = '' )
	  	if ask_for_published && custom_order.blank?
		  	Structure.friendly.find( slug ).components.published.order('position')
		  elsif custom_order.blank?
		  	Structure.friendly.find( slug ).components.order('position')
		  else
		  	Structure.friendly.find( slug ).components.order( custom_order )
		  end
	  end

	end
end