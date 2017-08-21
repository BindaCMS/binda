require 'colorize'
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
      puts 
      puts "============================================================================="
      puts "                               BINDA SETUP"
      puts "============================================================================="
      puts 
      puts "We need few details. Don't worry you can modify them later. \n\n"

      dashboard_structure = ::Binda::Structure.find_or_create_by( name: 'dashboard', slug: 'dashboard', instance_type: 'board' )
      @dashboard = dashboard_structure.board

      # By default each structure has a field group which will be used to store the default field settings
      field_settings = dashboard_structure.field_groups.first.field_settings


      # MAINTENANCE MODE
      puts "Setting up maintenance mode"

      # Use radio field_type untill truefalse isn't available
      maintenance_mode = field_settings.find_or_create_by!( name: 'Maintenance Mode', slug: 'maintenance-mode', field_type: 'radio' )
      # make sure slug works
      maintenance_mode.update_attributes( slug: 'maintenance-mode' )
      disabled = maintenance_mode.choices.create!( label: 'disabled', value: 'false' )
      active   = maintenance_mode.choices.create!( label: 'active', value: 'true' )
      @dashboard.radios.find_or_create_by!( field_setting_id: maintenance_mode.id )
      puts "The maintenance-mode option has been set up."
      puts


      # WEBSITE NAME
      puts "Setting up website name"

      website_name_obj = field_settings.find_or_create_by!( name: 'Website Name', slug: 'website-name', field_type: 'string' )
      # make sure slug works
      website_name_obj.update_attribute( 'slug', 'website-name' )
      website_name = ask("How would you like to name your website? ['MySite']\n").presence || 'MySite'
      @dashboard.strings.find_or_create_by!( field_setting_id: website_name_obj.id ).update_attribute('content', website_name )


      # WEBSITE CONTENT
      puts "Setting up website description"

      website_description_obj = field_settings.find_or_create_by!( name: 'Website Description', slug: 'website-description', field_type: 'text' )
      # make sure slug works
      website_description_obj.update_attribute( 'slug', 'website-description' )
      website_description = ask("What is your website about? ['A website about the world']\n").presence || 'A website about the world'
      @dashboard.texts.find_or_create_by!( field_setting_id: website_description_obj.id ).update_attribute( 'content', website_description )
    end

    def create_credentials
      rake 'binda:create_superadmin_user'
    end

    def feedback
      puts
      puts "============================================================================="
      puts
      puts "                Binda CMS has been succesfully installed! "
      puts
      puts "============================================================================="
      puts
      puts "Before deploying to production, remember to uncomment and update the"
      puts "'config.action_mailer.default_url_options' in 'config/environments/production.rb'"
      puts
      puts "============================================================================="
    end

  end
end
