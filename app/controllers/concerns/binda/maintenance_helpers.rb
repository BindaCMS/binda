module Binda
	module MaintenanceHelpers
		
		extend ActiveSupport::Concern

		included do
			before_action :force_redirect
			layout :get_layout
		end

		def is_maintenance_mode
			if ::Binda.get_boards('dashboard').includes(:radios).first.get_radio_choice('maintenance-mode')[:value] == 'true' && !user_signed_in?
				return true
			else
				return false
			end
		end

		private 

			def get_layout
				if is_maintenance_mode
					'maintenance'
				else
					'application'
				end
			end

			def force_redirect
				return redirect_to maintenance_path if request.original_url != maintenance_url && is_maintenance_mode
			end

	end
end