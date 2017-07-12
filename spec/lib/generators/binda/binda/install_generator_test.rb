require 'test_helper'
require 'generators/binda/install/install_generator'

module Binda
  class Binda::InstallGeneratorTest < Rails::Generators::TestCase
    tests Binda::InstallGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
