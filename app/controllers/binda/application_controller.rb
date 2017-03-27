module Binda
  class ApplicationController < ActionController::Base
    
    protect_from_forgery with: :exception

		before_action :authenticate_user!

	  def after_sign_in_path_for(resource_or_scope)
	 	  binda.settings_path
	  end

	  def after_sign_out_path_for(resource_or_scope)
	  	root_path
	  end

  end
end
