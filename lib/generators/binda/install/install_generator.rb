require 'securerandom'

module Binda
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

      def check_if_production
        if Rails.env.production?
          puts "Sorry Binda can only be installed in development mode"
          exit
        end
      end

      def check_previous_install
        # Ensure Binda is not installed
        if ActiveRecord::Base.connection.data_source_exists? 'binda_components'
          puts "Binda has already been installed on this database."
          puts "Please ensure Binda is completely removed from the database before trying to install it again."
          exit
        end
      end
      
      def run_migrations
        puts ""
        puts "==============================================================================="
        puts "                             BINDA INSTALLATION"
        puts "==============================================================================="
        puts ""
        puts "1) Install migrations"
        # Check if there is any previous Binda migration
        previous_binda_migrations = Dir.glob( Rails.root.join('db', 'migrate', '*.binda.rb' ))
        previous_migrations = Dir.glob( Rails.root.join('db', 'migrate', '*.rb' ))

        # If it's the first time you run the installation
        unless previous_binda_migrations.any?
          rake 'binda:install:migrations'
        else
          # If there is any previous Binda migration
          if previous_migrations.size != previous_binda_migrations.size
            puts "You have several migrations, please manually delete Binda's ones then run 'rails g binda:install' again."
            puts "Keep in mind that Binda will place the new migration after the existing ones."
            exit
          else
            # Remove previous Binda migrations
            FileUtils.rm_rf( previous_binda_migrations )
            # Install Binda migrations
            rake 'binda:install:migrations'
          end
        end
        rake 'db:migrate'
        
      end

      def add_route
        return if Rails.application.routes.routes.detect { |route| route.app.app == Binda::Engine }
        puts "2) Add Binda routes"
        route "mount Binda::Engine => '/admin_panel'"
      end


      # Setup Devise initializer
      # 
      # It append the snippet below to `config/initializers/devise.rb` of your application:
      # 
      # ```ruby
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
      #  ```
      def setup_devise
        puts "4) Setup Devise"
        # Check if devise is already setup and if so, create a backup before overwrite it
        initializers_path = Rails.root.join('config', 'initializers' )
        if File.exist?( "#{ initializers_path }/devise.rb" )
          puts "Binda has detected a configuration file for Devise: config/initializers/devise.rb"
          puts "In order to avoid any conflict that file has been renamed"
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
        end
      end

      # Setup Carrierwave
      # 
      # It generates this {file:lib/generators/binda/install/templates/confic/initializers/carrierwave.rb}
      def setup_carrierwave
        return if File.exist?( Rails.root.join('config', 'initializers', 'carrierwave.rb' ))
        puts "4) Setup Carrierwave"
        template 'config/initializers/carrierwave.rb'
        puts "==============================================================================="
      end

      def setup_settings
        exec 'rails generate binda:maintenance && rails generate binda:setup'
      end

  end
end