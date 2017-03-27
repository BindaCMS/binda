require 'colorize'

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

      def amend_devise
        # initializer "devise.rb" do
        #   "puts 'this is the beginning'"
        #   "config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'"
        #   "config.pepper = '3ae686c27e0413bd5b0a863730f082714caff4c040d987fd64367f0041e7e99f221a583cd3b0eaeb85408ce97d56ea59c00907a61b69988148f83d30f7ff92c3'"
        # end
        # 
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

      def feedback
        puts
        puts "Binda CMS has been succesfully installed! ".colorize(:green)
        puts
        puts "    Site name: #{ @website_name }"
        puts "    Site description: #{ @website_description }"
        puts
        puts "Restart your server and visit http://localhost:3000 in your browser!"
        puts "The admin panel is located at http://localhost:3000/admin_panel."
        puts
      end

  end
end