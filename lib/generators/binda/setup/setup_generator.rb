require 'colorize'
require 'securerandom'

module Binda
  class SetupGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

    def setup_settings
      puts 
      puts "============================================================================="
      puts "                               BINDA SETUP"
      puts "============================================================================="
      puts 
      puts "We need few details. Don't worry you can modify them later. \n\n"

      dashboard_structure = ::Binda::Structure.find_or_create_by( name: 'dashboard', slug: 'dashboard', instance_type: 'setting' )
      unless dashboard_structure.setting.nil?
        @dashboard = dashboard_structure.setting
      else
        @dashboard = dashboard_structure.create_setting( name: 'dashboard' )
      end

      # By default each structure has a field group which will be used to store the default field settings
      field_settings = dashboard_structure.field_groups.first.field_settings


      # MAINTENANCE MODE
      puts "Setting up maintenance mode"

      # Use radio field_type untill truefalse isn't available
      unless Binda::FieldSetting.where(slug: 'maintenance-mode').any?
        maintenance_mode = field_settings.find_or_create_by( name: 'Maintenance Mode', field_type: 'radio')
        maintenance_mode.update_attributes( slug: 'maintenance-mode' )
        active   = maintenance_mode.choices.create( label: 'active', value: 'true' )
        disabled = maintenance_mode.choices.create( label: 'disabled', value: 'false' )
        @dashboard.radios.find_or_create_by( field_setting_id: maintenance_mode.id )
      end
      puts "The maintenance-mode option has been set up."
      puts


      # WEBSITE NAME
      puts "Setting up website name"

      website_name = field_settings.find_or_create_by( name: 'Website Name', field_type: 'string' )
      website_name.update_attributes( slug: 'website-name' )
      @name = ask("How would you like to name your website? ['MySite']\n").presence || 'MySite'
      @dashboard.texts.find_or_create_by( field_setting_id: website_name.id ).update_attributes(content: @name )


      # WEBSITE CONTENT
      puts "Setting up website description"

      website_description = field_settings.find_or_create_by( name: 'Website Description', field_type: 'string' )
      website_description.update_attributes( slug: 'website-description' )
      @description = ask("What is your website about? ['A website about the world']\n").presence || 'A website about the world'
      @dashboard.texts.find_or_create_by( field_setting_id: website_description.id ).update_attributes( content: @description )
    end

    def create_credentials
      rake 'binda_create_initial_user'
    end

    def feedback
      puts
      puts "============================================================================="
      puts
      puts "                Binda CMS has been succesfully installed! ".colorize(:green)
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
