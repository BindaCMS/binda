ENV["RAILS_ENV"] = "test"

# this is VERY important as avoid loggin all warnings
# @see https://github.com/hanami/utils/issues/123
$VERBOSE=nil

require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output
# require "minitest/pride"

# https://github.com/DatabaseCleaner/database_cleaner#how-to-use
require 'database_cleaner'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  Rails.application.load_seed # loading seeds

  # Add more helper methods to be used by all tests here...
end

DatabaseCleaner.strategy = :transaction

class Minitest::Spec
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end