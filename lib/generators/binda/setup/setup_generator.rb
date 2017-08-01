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

      # MAINTENANCE MODE
      dashboard_structure = ::Binda::Structure.find_or_create_by( name: 'binda_dashboard', slug: 'binda_dashboard' )
      unless dashboard_structure.setting.nil?
        @dashboard = dashboard_structure.setting
      else
        @dashboard = dashboard_structure.create_setting( name: 'dashboard' )
      end

      # By default each structure has a field group which will be used to store the default field settings
      field_settings = dashboard_structure.field_groups.first.field_settings

      # MAINTENANCE MODE
      # Use radio field_type untill truefalse isn't available
      maintenance_mode = field_settings.find_or_create_by( name: 'Maintenance Mode', field_type: 'radio' )
      active   = maintenance_mode.choices.find_or_create_by( label: 'active', value: 'true' )
      disabled = maintenance_mode.choices.find_or_create_by( label: 'disabled', value: 'false' )
      maintenance_mode.default_choice = disabled
      @dashboard.radios.find_or_create_by( field_setting_id: maintenance_mode.id ).choices << maintenance_mode.default_choice

      # WEBSITE NAME
      website_name = field_settings.find_or_create_by( name: 'Website Name', field_type: 'string' )
      @website_name = ask("What would you like to name your website? ['MySite']\n").presence || 'MySite'

      @dashboard.texts.find_or_create_by( field_setting_id: website_name.id ).update_attributes(content: @website_name )

      # WEBSITE CONTENT
      website_description = field_settings.create( name: 'Website Description', field_type: 'string' )
      @website_description = ask("What is it about? ['A website about the world']\n").presence || 'A website about the world'
      @dashboard.texts.find_or_create_by( field_setting_id: website_description.id ).update_attributes( content: @website_description )
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
