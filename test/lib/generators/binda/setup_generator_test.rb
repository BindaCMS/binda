require 'test_helper'
require 'generators/binda/setup/setup_generator'

module Binda
  class SetupGeneratorTest < Rails::Generators::TestCase
    tests SetupGenerator
    # destination File.expand_path("../../../tmp", File.dirname(__FILE__))
    # destination Rails.root.join('test/tmp/generators')
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
