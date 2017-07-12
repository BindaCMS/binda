require 'test_helper'
require 'generators/binda/setup/setup_generator'

module Binda
  class Binda::SetupGeneratorTest < Rails::Generators::TestCase
    tests Binda::SetupGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
