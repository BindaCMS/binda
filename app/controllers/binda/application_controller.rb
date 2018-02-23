module Binda
  class ApplicationController < ActionController::Base
    
    protect_from_forgery with: :exception

		before_action :authenticate_user!
		before_action :set_locale

		# _ indicates that we are not using the argument in the method
	  def after_sign_in_path_for(_)
	 	  binda.dashboard_path
	  end

		# _ indicates that we are not using the argument in the method
	  def after_sign_out_path_for(_)
	  	root_path
	  end

	  # Avoid inheriting locale from application on which Binda is mounted
	  def set_locale
	  	I18n.locale = I18n.default_locale
	  end

  end
end
