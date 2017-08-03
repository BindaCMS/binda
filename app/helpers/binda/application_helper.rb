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

  	# Get url for the fieldable form
  	# 
  	# @param instance [object] The function expect an active record object.
    #   This can be an instance of `Binda::Component`, `Binda::Repeater` or `Binda::Setting`
  	def get_form_instance_url instance
  		# binding.pry
      return "structure_#{ instance.class.name.demodulize.underscore.pluralize }_path".send if action_name == 'new'
  		return "structure_#{ instance.class.name.demodulize.underscore }_path".send if action_name == 'edit'
  	end

    # Get url for new repeater
    # 
    # @param instance [object]
    def get_form_new_repeater instance
      return "structure_#{ instance.class.name.demodulize.underscore }_new_repeater_path".send( instance.structure, instance )
    end

    # Get url for sortable repeater fields
    # 
    # @param instance [object] Pass the active record object.
    def sort_instance_repeaters_url instance 
      "structure_#{ instance.class.name.demodulize.underscore }_sort_repeaters_path".send
    end

  end
end
