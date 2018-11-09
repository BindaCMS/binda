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

  	def get_form_manage_user_url
  		return manage_users_path if action_name == 'new'
  		return manage_user_path  if action_name == 'edit'
		end

		def check_field_errors(instance, attribute)
			key = "#{instance.class.name.parameterize}--#{instance.id.to_s}"
			unless @fields_errors[key].nil?
				instance.errors.add(attribute, @fields_errors[key][:message]);
			end
		end

  end
end
