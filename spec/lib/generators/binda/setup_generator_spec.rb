require "generator_spec"
require "rails_helper"
require "./lib/generators/binda/setup/setup_generator.rb"

module Binda
	describe SetupGenerator, type: :generator do
	  destination File.expand_path("../../tmp", __FILE__)

	  after(:all) do
	    ::DatabaseCleaner.strategy = :truncation
	    ::DatabaseCleaner.clean
	    # http://stackoverflow.com/a/19930700/1498118
	    ::Rails.application.load_seed # loading seeds
	    # Create first user
	    ::FactoryBot.create(:user)
	  end

		describe "executing from a brand new application" do	  

			before(:all) do
		    ::DatabaseCleaner.strategy = :truncation
		    ::DatabaseCleaner.clean

		    prepare_destination
		    # @old_stdin = STDIN
		    STDIN = StringIO.new("\n\n\n\n")
		    run_generator
		    # STDIN = @old_stdin
		  end

		  it "creates one maintenance mode field" do
		  	maintenance_mode_array = Binda::Radio
		  	  .where(
		  	  	field_setting_id: Binda::FieldSetting.where(
		  	  		slug: 'maintenance-mode'
		  	  	).ids
		  	  )
		    expect(maintenance_mode_array.length).to eq 1
		  end

		  it "assigns one choice to the maintenance mode field" do
	  	  maintenance_mode = Binda::Radio
		  	  .where(
		  	  	field_setting_id: Binda::FieldSetting.where(
		  	  		slug: 'maintenance-mode'
		  	  	).ids
		  	  ).first
		    expect(maintenance_mode.choices.length).to eq 1
			end

			it "set maintenance mode as disabled" do
				maintenance_mode_choice = Binda::Radio
		  	  .where(
		  	  	field_setting_id: Binda::FieldSetting.where(
		  	  		slug: 'maintenance-mode'
		  	  	)
		  	  	.ids
		  	  )
		  	  .first
		  	  .choices
		  	  .first
		    expect(maintenance_mode_choice.label).to eq 'disabled'
		    expect(maintenance_mode_choice.value).to eq 'false'
			end

		end


		describe "executing from an existing application" do

		  before(:all) do
		    ::DatabaseCleaner.strategy = :truncation
		    ::DatabaseCleaner.clean
			
		    prepare_destination
		    # @old_stdin = STDIN
		    STDIN = StringIO.new("mail@admin.com\npassword\nWebsite name\nWebsite description\n")
		    run_generator
		    # STDIN = @old_stdin
		  end

		  it "can create a default user" do
		    expect(Binda::User.where(email: 'mail@admin.com').present?).to be true
			end
		end
	end
end