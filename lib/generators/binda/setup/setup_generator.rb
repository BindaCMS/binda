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
      ::Binda::Setting.find_or_create_by( name: 'Maintenance Mode' )

      # WEBSITE NAME
      @website_name = ask("What would you like to name your website? ['MySite']\n").presence || 'MySite'
      ::Binda::Setting.find_or_create_by( name: 'Website Name' ).update_attribute( :content, @website_name )

      # WEBSITE CONTENT
      @website_description = ask("What is it about? ['A website about the world']\n").presence || 'A website about the world'
      ::Binda::Setting.find_or_create_by( name: 'Website Description' ).update_attribute( :content, @website_description )
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
