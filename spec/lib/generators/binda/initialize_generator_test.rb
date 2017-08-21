require 'test_helper'
require 'generators/binda/initialize/initialize_generator'

module Binda
  class InitializeGeneratorTest < Rails::Generators::TestCase
    tests InitializeGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
