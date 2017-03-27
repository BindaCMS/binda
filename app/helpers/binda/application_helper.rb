module Binda
  module ApplicationHelper

		def main_app
		  Rails.application.class.routes.url_helpers
		end

	  def is_devise_controller
	  	devise_controllers = [
	  		'confirmations', 
	  		'omniauth_callbacks', 
	  		'passwords',
	  		'sessions',
	  		'unlocks'
	  	]
	  	devise_controllers.include? controller_name
	  end

  end
end
