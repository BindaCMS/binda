require 'colorize'
require 'securerandom'

module Binda
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
      
      def check_previous_install
        # Ensure Binda is not installed
        if ::Binda::Component.table_exists?
          puts "Binda has already been installed on this database.".colorize(:red)
          puts "Please ensure Binda is completely removed from the database before trying to install it again.".colorize(:red)
          exit
        end
      end

      def add_route
        return if Rails.env.production?
        return if Rails.application.routes.routes.detect { |route| route.app.app == Binda::Engine }
        route "mount Binda::Engine => '/admin_panel'"
      end

      def add_helpers
        ac_path = Rails.root.join('app', 'controllers', 'application_controller.rb' )
        unless File.readlines(ac_path).grep(/::Binda::DefaultHelpers/).size > 0
          inject_into_file ac_path, after: "ActionController::Base" do 
            "\n  include ::Binda::DefaultHelpers"
          end
        end
      end

      def copy_migrations
        return if Rails.env.production?

        # Check if there is any previous Binda migration
        previous_binda_migrations = Dir.glob( Rails.root.join('db', 'migrate', '*.binda.rb' ))
        previous_migrations = Dir.glob( Rails.root.join('db', 'migrate', '*.rb' ))

        # If it's the first time you run the installation
        unless previous_binda_migrations.any?
          rake 'binda:install:migrations'
        else
          # If there is any previous Binda migration
          if previous_migrations.size != previous_binda_migrations.size
            puts "You have several migrations, please manually delete Binda's ones then run 'rails g binda:install' again.".colorize(:red)
            puts "Keep in mind that Binda will place the new migration after the existing ones.".colorize(:red)
            exit
          else
            # Remove previous Binda migrations
            FileUtils.rm_rf( previous_binda_migrations )
            # Install Binda migrations
            rake 'binda:install:migrations'
          end
        end
      end
      
      def run_migrations
        rake 'db:migrate'
      end

      def setup_devise
        return if Rails.env.production?

        # Check if devise is already setup and if so, create a backup before overwrite it
        initializers_path = Rails.root.join('config', 'initializers' )
        if File.exist?( "#{ initializers_path }/devise.rb" )
          puts "We have detected a configuration file for Devise: config/initializers/devise.rb".colorize(:green)
          puts "In order to avoid any conflict that file has been renamed".colorize(:green)
          File.rename( "#{ initializers_path }/devise.rb" , "#{ initializers_path }/devise_backup_#{ Time.now.strftime('%Y%m%d-%H%M%S-%3N') }.rb" )
        end
        
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
        return if File.exist?( Rails.root.join('config', 'initializers', 'carrierwave.rb' ))
        
        template 'config/initializers/carrierwave.rb'
      end

      def setup_settings
        exec 'rails g binda:setup'
      end

  end
end