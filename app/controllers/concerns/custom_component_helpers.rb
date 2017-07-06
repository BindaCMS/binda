module CustomComponentHelpers 
	extend ActiveSupport::Concern

  def get_components( slug, ask_for_published = true, custom_order = '' )
  	if ask_for_published && custom_order.blank?
	  	Binda::Structure.friendly.find( slug ).components.published.order('position')
	  elsif custom_order.blank?
	  	Binda::Structure.friendly.find( slug ).components.order('position')
	  else
	  	Binda::Structure.friendly.find( slug ).components.order( custom_order )
	  end
  end

end