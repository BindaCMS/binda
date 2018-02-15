require 'securerandom'

module Binda
  # Setup initial settings for the application.
  # 
  # This is setup is mandatory as sets the initial super admin user and 
  #   the default dashboard where are stored the main application settings.
  #   It is useful also when Binda has been already installed once but the
  #   database has been reset. Runnin `rails g binda:setup` will populate 
  #   the application database with new default settings.
  class SetupGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

    def setup_settings
      puts "Implement Binda settings"
      puts 

      dashboard_structure = Structure.find_or_create_by( name: 'dashboard', slug: 'dashboard', instance_type: 'board' )
      @dashboard = dashboard_structure.board

      # By default each structure has a field group which will be used to store the default field settings
      @field_settings = dashboard_structure.field_groups.first.field_settings
    end

    def create_credentials
      puts "1) Create a superadmin user"
      User.create_super_admin_user
      puts 
    end

    def setup_maintenance_mode
      puts "2) Setting up maintenance mode"

      # Use radio field_type untill truefalse isn't available
      unless FieldSetting.find_by(slug: 'maintenance-mode').present?
        maintenance_mode = @field_settings.create!( name: 'Maintenance Mode', field_type: 'radio', position: 1, allow_null: false, slug: 'maintenance-mode' )
        # create active and disabled choices
        disabled = maintenance_mode.choices.create!( label: 'disabled', value: 'false' )
        maintenance_mode.choices.create!( label: 'active', value: 'true' )

        # assign disabled choice and remove the temporary choice
        @dashboard.reload
        @dashboard.radios.first.choices << disabled
        unwanted = @dashboard.radios.first.choices.select{|choice| choice.label != 'disabled'}
        unwanted.each{|choice| choice.destroy} if unwanted.any?
      end
      puts "The maintenance-mode option has been set up."
      puts 
    end

    def setup_website_name 
      puts "3) Setting up website name"
      puts "Don't worry you can modify it later."

      name_field_setting = FieldSetting.find_by(slug: 'website-name')
      unless name_field_setting.present?
        name_field_setting = @field_settings.create!( name: 'Website Name', field_type: 'string', position: 2 )
        # make sure slug works
        name_field_setting.update_attribute( 'slug', 'website-name' )
      end
      STDOUT.puts "How would you like to name your website? ['MySite']"
      website_name = STDIN.gets
      website_name = 'MySite' if website_name.blank?
      @dashboard.strings.find_or_create_by( field_setting_id: name_field_setting.id ).update_attribute('content', website_name )
      puts 
    end

    def setup_website_content
      puts "4) Setting up website description"
      puts "Don't worry you can modify it later."

      description_field_setting = FieldSetting.find_by(slug: 'website-description')
      unless description_field_setting.present?
        description_field_setting = @field_settings.find_or_create_by( name: 'Website Description', field_type: 'text', position: 3 )
        # make sure slug works
        description_field_setting.update_attribute( 'slug', 'website-description' )
      end
    
      STDOUT.puts "What is your website about? ['A website about the world']"
      website_description = STDIN.gets
      website_description = 'A website about the world' if website_description.blank?
      @dashboard.texts.find_or_create_by!( field_setting_id: description_field_setting.id ).update_attribute( 'content', website_description )
      puts 
    end

    def feedback
      puts "==============================================================================="
      puts
      puts "                 Binda CMS has been succesfully installed! "
      puts
      puts "==============================================================================="
      puts
      puts "Before deploying to production, remember to uncomment and update the"
      puts "'config.action_mailer.default_url_options' in 'config/environments/production.rb'"
      puts
      puts "==============================================================================="
    end

  end
end
