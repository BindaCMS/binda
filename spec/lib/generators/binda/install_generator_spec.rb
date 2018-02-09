require "generator_spec"
require "rails_helper"
require "./lib/generators/binda/install/install_generator.rb"

require 'rake'

module Binda
	describe InstallGenerator, type: :generator do
		destination File.expand_path("../../tmp", __FILE__)

		after(:context) do
			system "rails db:migrate RAILS_ENV=test"
			::DatabaseCleaner.strategy = :truncation
			::DatabaseCleaner.clean
			::Rails.application.load_seed
			::FactoryBot.create(:user)
		end

		describe "executing from a brand new application" do

			before(:context) do

				# TODO setup properly

				# assuming there is one only migration
				# system "rails db:rollback"
				# # https://stackoverflow.com/a/15350752/1498118
				# # https://apidock.com/rails/Rails/Engine/load_tasks
				# # ::Rails::Engine.config.load_tasks
				# # wait at least 10 sec so we can be sure migration are setup properly
				# # REVIEW it'd be best to use a callback instead of waiting X amount of time
				# sleep 10
				# prepare_destination
				# run_generator
			end

			it "checks if production" do
				skip("To be implemented")
			end
			it "exits if previous install is present" do
				skip("To be implemented")
			end
			it "runs migrations" do
				skip("To be implemented")
			end
			it "adds routes" do
				skip("To be implemented")
			end
			it "setups devise" do
				skip("To be implemented")
			end
			it "setups carrierwave" do
				skip("To be implemented")
			end
			it "setups defalt helpers" do
				skip("To be implemented")
			end
			it "launches binda setup and maintenance mode setup" do
				skip("To be implemented")
			end
		end
	end	
end