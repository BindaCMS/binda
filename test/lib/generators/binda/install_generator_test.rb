require 'test_helper'
require 'generators/binda/install/install_generator'

module Binda
  class InstallGeneratorTest < Rails::Generators::TestCase
    include GeneratorTestHelpers
    tests InstallGenerator
    # destination File.expand_path("../tmp", File.dirname(__FILE__))
    destination Rails.root.join('tmp')
    setup :prepare_destination

    create_generator_sample_app

    Minitest.after_run do
      remove_generator_sample_app
    end

    # setup do
    #   run_generator
    # end

    test "generator runs without errors" do
      assert_nothing_raised do
        puts "porco"
        run_generator
      end
    end
  end
end
