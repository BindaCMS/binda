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
			puts "It seems you have already upgraded to v0.0.7"
			exit
		end

		if Binda::Structure.where(slug: 'dashboard').any?
			puts "A Binda::Structure with `slug = 'dashboard'` has been detected in your database."
			puts "In order to upgrade Binda, the structure's name and slug will be set to 'dashboard-backup'"
			Binda::Structure.where(slug: 'dashboard').update_all(name: 'dashboard-backup')
		end

		# DASHBOARD
		dashboard_structure = Binda::Structure.create( name: 'dashboard', slug: 'dashboard', instance_type: 'board' )
	  @dashboard = dashboard_structure.board

		# By default each structure has a field group which will be used to store the default field settings
		field_settings = dashboard_structure.field_groups.first.field_settings

		# MAINTENANCE MODE
		puts "Setting up maintenance mode"
    unless Binda::FieldSetting.find_by(slug: 'maintenance-mode').present?
      maintenance_mode = field_settings.create!( name: 'Maintenance Mode', field_type: 'radio' )
      # make sure slug works
      maintenance_mode.update_attributes( slug: 'maintenance-mode' )
      maintenance_mode.choices.create!( label: 'disabled', value: 'false' )
      maintenance_mode.choices.create!( label: 'active', value: 'true' )
      @dashboard.radios.find_or_create_by!( field_setting_id: maintenance_mode.id )
    end


		# WEBSITE NAME
		puts "Setting up website name"
    website_name_obj = Binda::FieldSetting.find_by(slug: 'website-name')
    unless website_name_obj.present?
      website_name_obj = field_settings.create!( name: 'Website Name', field_type: 'string' )
      # make sure slug works
      website_name_obj.update_attribute( 'slug', 'website-name' )
			old_name_record = Binda::Board.where(slug: 'website-name')
			if old_name_record.any?
				@dashboard.texts.find_or_create_by( field_setting_id: website_name_obj.id ).update_attribute('content', old_name_record.first.content )
			else
	      website_name = ask("How would you like to name your website? ['MySite']\n").presence || 'MySite'
	      @dashboard.strings.find_or_create_by( field_setting_id: website_name_obj.id ).update_attribute('content', website_name )
			end
    end

		# WEBSITE CONTENT
		puts "Setting up website description"
    website_description_obj = Binda::FieldSetting.find_by(slug: 'website-description')
    unless website_description_obj.present?
      website_description_obj = field_settings.find_or_create_by( name: 'Website Description', field_type: 'text' )
      # make sure slug works
      website_description_obj.update_attribute( 'slug', 'website-description' )
			old_description_record = Binda::Board.where(slug: 'website-name')
			if old_description_record.any?
				@dashboard.texts.find_or_create_by( field_setting_id: website_description_obj.id ).update_attribute( 'content', old_description_record.first.content )
			else
		    website_description = ask("What is your website about? ['A website about the world']\n").presence || 'A website about the world'
		    @dashboard.texts.find_or_create_by!( field_setting_id: website_description_obj.id ).update_attribute( 'content', website_description )
			end
    end
    
	end
end