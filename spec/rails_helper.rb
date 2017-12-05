# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../dummy/config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!


# LIBRARIES
# ---------

# https://github.com/plataformatec/devise/wiki/How-To:-Test-controllers-with-Rails-3-and-4-%28and-RSpec%29#controller-specs
require 'devise'
# https://github.com/teamcapybara/capybara#using-capybara-with-rspec
require 'capybara/rspec'
# https://github.com/thoughtbot/factory_bot_rails/issues/167#issuecomment-226360492
require 'factory_bot_rails'
# https://github.com/DatabaseCleaner/database_cleaner#how-to-use
require 'database_cleaner'
require 'pry'

# JAVASCRIPT DRIVER
# -----------------
# In order to use Poltergeist please make sure you have Phantom JS installed before testing
# https://github.com/teampoltergeist/poltergeist/tree/v1.16.0#installing-phantomjs
# require 'capybara/poltergeist'
# Capybara.javascript_driver = :poltergeist
# Capybara.javascript_driver = :poltergeist_debug
# Capybara.register_driver :poltergeist_debug do |app|
  # Capybara::Poltergeist::Driver.new(app, :inspector => true)
# end
#
# As Poltergeist doesn't work with OSX (see http://www.jonathanleighton.com/articles/2012/poltergeist-0-6-0/)
# We are going to use Selenium Webdriver
# Capybara.register_driver :selenium do |app|
#   Capybara::Selenium::Driver.new(app, :browser => :chrome)
# end
Capybara.javascript_driver = :selenium


# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Binda::Engine.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

# RSPEC CONFIGURATION
# -------------------

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")


  # DEVISE
  # ------
  # Include Devise Helper
  # https://github.com/plataformatec/devise/wiki/How-To:-Test-with-Capybara
  # (are u sure that the following line is working?)
  include Warden::Test::Helpers
  # https://github.com/plataformatec/devise#test-helpers
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  # https://github.com/plataformatec/devise#integration-tests
  config.include Devise::Test::IntegrationHelpers, type: :feature


  # FACTORY GIRL
  # ------------
  # Include Factory Girl Methods
  # https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md
  config.include FactoryBot::Syntax::Methods


  # CLEAN TEST DATABASE BEFORE TESTING
  # ----------------------------------
  # https://github.com/DatabaseCleaner/database_cleaner#rspec-with-capybara-example
  # https://github.com/DatabaseCleaner/database_cleaner#rspec-example
  config.before(:suite) do

    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
    
    # http://stackoverflow.com/a/19930700/1498118
    Rails.application.load_seed # loading seeds

    FactoryBot.create(:user)
  end

  # CARRIERWAVE
  # -----------
  # Clean uploaded files after each request.
  # https://til.codes/testing-carrierwave-file-uploads-with-rspec-and-factorygirl/

  config.after(:each) do
    if Rails.env.test? || Rails.env.cucumber?
      FileUtils.rm_rf(Dir["#{Binda::Engine.root}/spec/support/uploads"])
    end 
  end
end
