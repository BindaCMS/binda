require 'colorize'
require 'securerandom'

module Binda
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
      
      def check_previous_install
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
        # Clean the application from any previous Binda installation
        prev_migrations = Dir.glob( Rails.root.join('db', 'migrate', '*_binda_*.rb' )) 
        FileUtils.rm_rf( prev_migrations ) if prev_migrations.any?
        # Make a fresch copy of Binda migrations
        rake 'binda:install:migrations'
      end
      
      def run_migrations
        rake 'db:migrate'
      end

      def setup_devise
        return if Rails.env.production?
        template 'config/initializers/devise.rb'
        inject_into_file 'config/initializers/devise.rb', after: "config.secret_key = '" do 
          SecureRandom.hex(64)
        end
        inject_into_file 'config/initializers/devise.rb', after: "config.pepper = '" do 
          SecureRandom.hex(64)
        end
      end

      def setup_carrierwave
        return if Rails.env.production?
        template 'config/initializers/carrierwave.rb'
      end

      def setup_settings
        puts "======================================================"
        puts "                    BINDA SETUP"
        puts "======================================================"
        puts 
        puts "We need few details. Don't worry you can modify them later. \n\n"

        # WEBSITE NAME
        @website_name = ask("What would you like to name your website? ['MySite']").presence || 'MySite'
        Setting.find_or_create_by( name: 'website_name' ).update_attribute( :content, @website_name )

        # WEBSITE CONTENT
        @website_description = ask("What is it about? ['A website about the world']").presence || 'A website about the world'
        Setting.find_or_create_by( name: 'website_description' ).update_attribute( :content, @website_description )
      end

      def create_credentials
        @username = ask("What's your email? ['admin@domain.com']").presence || 'admin@domain.com'
        @password = ask("What's your password? ['password']").presence || 'password'
        Binda::User.create({ email: @username, password: @password })
      end

      def feedback
        puts
        puts "Binda CMS has been succesfully installed! ".colorize(:green)
        puts
        puts "    Title:              #{ @website_name }"
        puts "    Description:        #{ @website_description }"
        puts "    Username:           #{ @username }"
        puts "    Password:           #{ @password }"
        puts
        puts "Restart your server and visit http://localhost:3000 in your browser!"
        puts "The admin panel is located at http://localhost:3000/admin_panel."
        puts
        puts "======================================================"
      end

  end
end