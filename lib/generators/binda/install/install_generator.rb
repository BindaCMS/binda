require 'colorize'

module Binda
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
      
      def check_previous_install
        # Setup HighLine instance
        # https://github.com/JEG2/highline
        @ask = ::HighLine.new
        # Ensure Binda is not installed
        if Page.table_exists?
          puts "Binda has already been installed on this database.".colorize(:red)
          puts "Please ensure Binda is completely removed from the database before trying to install it again."
          exit
        end
      end

      def add_route
        return if Rails.env.production?
        return if Rails.application.routes.routes.detect { |route| route.app.app == Binda::Engine }
        route "mount Binda::Engine => '/admin_panel'"
      end

      def copy_migrations
        return if Rails.env.production?
        rake 'binda:install:migrations'
      end
      
      def run_migrations
        rake 'db:migrate'
      end

      def setup_settings
        puts "============================================"
        puts "               BINDA SETUP"
        puts "============================================"
        return if Setting.where( name: 'website_name' ).exists? && @ask.agree('Website name already exists. Skip? [y/n]')
        website_name = Setting.where( name: 'website_name' ).try(:content) || 'MySite'
        website_name = ask("What would you like to name your website? [#{website_name}]").presence || website_name
        Setting.find_or_create_by( name: 'website_name' ).update_attribute( :content, website_name )
      end

      def feedback
        puts
        puts "    Binda CMS has been succesfully installed! ".colorize(:green)
        puts
        puts "    Restart your server and visit http://localhost:3000 in your browser!"
        puts "    The admin panel is located at http://localhost:3000/admin_panel."
        puts
        puts "    Site name : #{Setting.find_by( name: 'website_name' ).content}"
        puts
      end

  end
end