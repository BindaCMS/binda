require 'colorize'

namespace :binda do 

	desc "Create super admin user"
	task :create_superadmin_user => :environment do
		STDOUT.puts "What is your email? [mail@domain.com]"
	  username = STDIN.gets.strip
	  username = 'mail@domain.com' if username.blank?
		STDOUT.puts "What is your password? [password]"
	  password = STDIN.gets.strip
	  password = 'password' if password.blank?
	  Binda::User.create!( email: username, password: password, password_confirmation: password, is_superadmin: true )
	end

	desc "Update Binda to v0.0.7"
	task :upgrade_to_v007 => :environment do

		# Make sure Binda hasn't been upgraded already
		check_structure = Binda::Structure.where(slug: 'dashboard').any?
		check_field_settings = Binda::FieldSetting.where(slug: ['maintenance-mode', 'website-name', 'website-description']).length == 3
		if check_structure && check_field_settings
			puts "It seems you have already upgraded to v0.0.7".colorize(:red)
			exit
		end

		if Binda::Structure.where(slug: 'dashboard').any?
			puts "A Binda::Structure with `slug = 'dashboard'` has been detected in your database.".colorize(:red)
			puts "In order to upgrade Binda, the structure's name and slug will be set to 'dashboard-backup'".colorize(:red)
			Binda::Structure.where(slug: 'dashboard').update_all(name: 'dashboard-backup')
		end
		# DASHBOARD
		dashboard_structure = Binda::Structure.create( name: 'dashboard', slug: 'dashboard', instance_type: 'board' )
		unless dashboard_structure.board.nil?
		  @dashboard = dashboard_structure.board
		else
		  @dashboard = dashboard_structure.create_board( name: 'dashboard' )
		end
		# By default each structure has a field group which will be used to store the default field settings
		field_settings = dashboard_structure.field_groups.first.field_settings

		# MAINTENANCE MODE
		puts "Setting up maintenance mode"
		unless Binda::FieldSetting.where(slug: 'maintenance-mode').any?
			maintenance_mode = field_settings.create( name: 'Maintenance Mode', field_type: 'radio')
			maintenance_mode.update_attributes( slug: 'maintenance-mode' )
			active   = maintenance_mode.choices.create( label: 'active', value: 'true' )
			disabled = maintenance_mode.choices.create( label: 'disabled', value: 'false' )
			@dashboard.radios.find_or_create_by( field_setting_id: maintenance_mode.id ).choices << disabled
		end


		# WEBSITE NAME
		puts "Setting up website name"
		unless Binda::FieldSetting.where(slug: 'website-name').any?
			website_name = field_settings.create( name: 'Website Name', field_type: 'string' )
			website_name.update_attributes( slug: 'website-name' )
			old_name_record = Binda::Board.where(slug: 'website-name')
			if old_name_record.any?
				@dashboard.texts.find_or_create_by( field_setting_id: website_name.id ).update_attributes(content: old_name_record.first.content )
			else
				@dashboard.texts.find_or_create_by( field_setting_id: website_name.id ).update_attributes(content: 'MySite' )
			end
		end

		# WEBSITE CONTENT
		puts "Setting up website description"
		unless Binda::FieldSetting.where(slug: 'website-description').any?
			website_description = field_settings.create( name: 'Website Description', field_type: 'string' )
			website_description.update_attributes( slug: 'website-description' )
			old_description_record = Binda::Board.where(slug: 'website-name')
			if old_description_record.any?
				@dashboard.texts.find_or_create_by( field_setting_id: website_description.id ).update_attributes( content: old_description_record.first.content )
			else
				@dashboard.texts.find_or_create_by( field_setting_id: website_description.id ).update_attributes( content: 'A website about the world' )
			end
		end
	end
end