module Binda
  class ApplicationController < ActionController::Base
    
    protect_from_forgery with: :exception

		before_action :authenticate_user!

		# _ indicates that we are not using the argument in the method
	  def after_sign_in_path_for(_)
	 	  binda.dashboard_path
	  end

		# _ indicates that we are not using the argument in the method
	  def after_sign_out_path_for(_)
	  	root_path
	  end

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
end
