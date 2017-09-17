class Binda::MaintenanceGenerator < Rails::Generators::Base
	source_root File.expand_path('../templates', __FILE__)

	def add_controller
		puts "Maintenance page setup"
		puts ""
		puts "1) Adding controller"
		if File.exist?(Rails.root.join('app', 'controllers', 'maintenance_controller.rb' ))
			puts "-------------------------------------------------------------------------------"
			puts "WARNING: Apparently you have already a controller named MaintenanceController."
			puts "Unless you know what you are doing, delete it and run the generator again."
			puts "-------------------------------------------------------------------------------"
			exit
		end
		generate "controller", "maintenance index --no-assets --no-helper"
		inject_into_file Rails.root.join('app', 'controllers', 'maintenance_controller.rb'), after: "def index" do
			"\n render template: 'layouts/maintenance'"
		end
	end

	def add_templates
		puts "2) Adding templates"
		template 'app/assets/javascripts/maintenance.js'
		template 'app/assets/stylesheets/maintenance.scss'
		template 'app/views/layouts/maintenance.html.erb'
		template 'config/initializers/maintenance.rb'
	end

	def add_route
		return if Rails.application.routes.named_routes.any?{ |key, _| key.to_s === "maintenance" }
		# replace 'maintenance/index' root with 'maintenance'
		route "get 'maintenance', to: 'maintenance#index', as: 'maintenance'"
		gsub_file Rails.root.join('config', 'routes.rb'), "get 'maintenance/index'", ""
	end

	def add_helper
		ac_path = Rails.root.join('app', 'controllers', 'application_controller.rb' )
		unless File.readlines(ac_path).grep(/::Binda::MaintenanceHelpers/).size > 0
			inject_into_file ac_path, after: "ActionController::Base" do 
				"\n  include ::Binda::MaintenanceHelpers"
			end
		end
	end

	def end
		puts ""
		puts "Maintenance page setup completed! Yay!"
		puts "==============================================================================="
	end
end
