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
        # Make a fresh copy of Binda migrations
        rake 'binda:install:migrations'
      end
      
      def run_migrations
        rake 'db:migrate'
      end

      def setup_devise
        return if Rails.env.production?
        # Copy the initilializer on the application folder
        template 'config/initializers/devise.rb'

        # Add secret key
        inject_into_file 'config/initializers/devise.rb', after: "# binda.hook.1" do 
          "\n  config.secret_key = '#{ SecureRandom.hex(64) }'"
        end
        # Add pepper
        inject_into_file 'config/initializers/devise.rb', after: "# binda.hook.2" do 
          "\n  config.pepper = '#{ SecureRandom.hex(64) }'"
        end

        application( nil, env: [ "development", "test" ] ) do
          "\n  config.action_mailer.default_url_options = { host: 'localhost:3000' }\n  config.action_mailer.raise_delivery_errors = true\n"
        end
        application( nil, env: "production" ) do
          "\n  # PLEASE UPDATE THIS WITH THE FINAL URL OF YOUR DOMAIN\n  # config.action_mailer.default_url_options = { host: 'yourdomain.com' }\n  # config.action_mailer.delivery_method = :smtp\n  # config.action_mailer.perform_deliveries = true\n  # config.action_mailer.raise_delivery_errors = false\n  # config.action_mailer.default :charset => 'utf-8'\n  # config.action_mailer.smtp_settings = {\n  #   address: 'smtp.gmail.com',\n  #   port: 587,\n  #   domain: ENV['MAIL_DOMAIN'],\n  #   authentication: 'plain',\n  #   enable_starttls_auto: true,\n  #   user_name: ENV['MAIL_USERNAME'],\n  #   password: ENV['MAIL_PASSWORD']\n  # }"

            # which returns the snippet below:
            # 
            #  # PLEASE UPDATE THIS WITH THE FINAL URL OF YOUR DOMAIN
            #  # for setup see https://rubyonrailshelp.wordpress.com/2014/01/02/setting-up-mailer-using-devise-for-forgot-password/
            #  config.action_mailer.default_url_options = { host: 'yourdomain.com' }
            #  config.action_mailer.delivery_method = :smtp
            #  config.action_mailer.perform_deliveries = true
            #  config.action_mailer.raise_delivery_errors = false
            #  config.action_mailer.default :charset => 'utf-8'
            #  config.action_mailer.smtp_settings = {
            #    address: 'smtp.gmail.com',
            #    port: 587,
            #    domain: ENV['MAIL_DOMAIN'],
            #    authentication: 'plain',
            #    enable_starttls_auto: true,
            #    user_name: ENV['MAIL_USERNAME'],
            #    password: ENV['MAIL_PASSWORD']
            #  }
        end
      end

      def setup_carrierwave
        return if Rails.env.production?
        template 'config/initializers/carrierwave.rb'
      end


      def setup_settings
        puts 
        puts "============================================================================="
        puts "                               BINDA SETUP"
        puts "============================================================================="
        puts 
        puts "We need few details. Don't worry you can modify them later. \n\n"

        # MAINTENANCE MODE
        Setting.find_or_create_by( name: 'Maintenance Mode' )

        # WEBSITE NAME
        @website_name = ask("What would you like to name your website? ['MySite']").presence || 'MySite'
        Setting.find_or_create_by( name: 'Website Name' ).update_attribute( :content, @website_name )

        # WEBSITE CONTENT
        @website_description = ask("What is it about? ['A website about the world']").presence || 'A website about the world'
        Setting.find_or_create_by( name: 'Website Description' ).update_attribute( :content, @website_description )
      end

      def create_credentials
        rake 'binda_create_initial_user'
      end

      def feedback
        puts
        puts "Binda CMS has been succesfully installed! ".colorize(:green)
        puts
        # puts "    Title:              #{ @website_name }"
        # puts "    Description:        #{ @website_description }"
        # puts "    Username:           #{ Binda::User.first.email }"
        # puts
        # puts "Restart your server and visit http://localhost:3000 in your browser!"
        # puts "The admin panel is located at http://localhost:3000/admin_panel."
        # puts
        puts "Before deploying to production, remember to uncomment and update the"
        puts "'config.action_mailer.default_url_options' in 'config/environments/production.rb'"
        puts
        puts "============================================================================="
      end

  end
end