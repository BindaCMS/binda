require 'test_helper'
require 'generators/binda/install/install_generator'

module Binda
  class InstallGeneratorTest < Rails::Generators::TestCase
    tests InstallGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    it 'should run all tasks in the generator' do
      run_generator
    end

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
