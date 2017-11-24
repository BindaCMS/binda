ENV["RAILS_ENV"] = "test"
require File.expand_path("../../spec/dummy/config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/reporters"
# require 'database_cleaner'
require 'minitest/autorun'
require 'factory_girl'
# require "pry"
# require "byebug"

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output
# require "minitest/pride"

# class ActiveSupport::TestCase
#   # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
#   fixtures :all
#   # Add more helper methods to be used by all tests here...
# end


Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

class Minitest::Unit::TestCase
  include FactoryGirl::Syntax::Methods
end

FactoryGirl.find_definitions

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection


# CLEAN TEST DATABASE BEFORE TESTING
# ----------------------------------
# https://github.com/DatabaseCleaner/database_cleaner#minitest-example
# DatabaseCleaner.strategy = :transaction
# DatabaseCleaner.clean_with(:truncation)

# class Minitest::Test
	
  # def setup
  #   DatabaseCleaner.start
  # end

  # def teardown
  #   DatabaseCleaner.clean
  # end
# end