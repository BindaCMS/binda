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

      dashboard_structure = ::Binda::Structure.find_or_create_by( name: 'dashboard', slug: 'dashboard', instance_type: 'board' )
      @dashboard = dashboard_structure.board

      # By default each structure has a field group which will be used to store the default field settings
      @field_settings = dashboard_structure.field_groups.first.field_settings
    end

    def create_credentials
      puts "1) Create a superadmin user"
      rake 'binda:create_superadmin_user'
      puts 
    end

    def setup_maintenance_mode
      puts "2) Setting up maintenance mode"

      # Use radio field_type untill truefalse isn't available
      unless @field_settings.find_by(slug: 'maintenance-mode').present?
        maintenance_mode = @field_settings.create!( name: 'Maintenance Mode', field_type: 'radio', position: 1 )
        # make sure slug works
        maintenance_mode.update_attributes( slug: 'maintenance-mode' )
        # create active and disabled choices
        maintenance_mode.choices.create!( label: 'active', value: 'true' )
        maintenance_mode.choices.create!( label: 'disabled', value: 'false' )
        @dashboard.radios.find_or_create_by!( field_setting_id: maintenance_mode.id )
      end
      puts "The maintenance-mode option has been set up."
      puts 
    end

    def setup_website_name 
      puts "3) Setting up website name"
      puts "We need few details. Don't worry you can modify them later."

      website_name_obj = @field_settings.find_by(slug: 'website-name')
      unless website_name_obj.present?
        website_name_obj = @field_settings.create!( name: 'Website Name', field_type: 'string', position: 2 )
        # make sure slug works
        website_name_obj.update_attribute( 'slug', 'website-name' )
      end
      website_name = ask("How would you like to name your website? ['MySite']\n").presence || 'MySite'
      @dashboard.strings.find_or_create_by( field_setting_id: website_name_obj.id ).update_attribute('content', website_name )
    end

    def setup_website_content
      puts "4) Setting up website description"

      website_description_obj = @field_settings.find_by(slug: 'website-description')
      unless website_description_obj.present?
        website_description_obj = @field_settings.find_or_create_by( name: 'Website Description', field_type: 'text', position: 3 )
        # make sure slug works
        website_description_obj.update_attribute( 'slug', 'website-description' )
      end
      website_description = ask("What is your website about? ['A website about the world']\n").presence || 'A website about the world'
      @dashboard.texts.find_or_create_by!( field_setting_id: website_description_obj.id ).update_attribute( 'content', website_description )
    end

    # Setup default helpers
    # 
    # This operation creates a class called `B` from which is possible to call any
    #   Binda helper contained in Binda::DefaultHelpers. This is possible by inheriting the
    #   `Binda::B` class.
    def setup_default_helpers
      puts "5) Setting up default helpers"
      generate "model", "B --no-migration --parent=::Binda::B"
      puts "Default helpers has been set up."
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
