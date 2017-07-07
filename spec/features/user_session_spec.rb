require "rails_helper"

describe "User session", type: :feature do

	let(:user){ Binda::User.first }

	it "redirects to login if user isn't logged in" do
		visit binda.structures_path
		expect( page ).not_to have_current_path( binda.structures_path )
	end

	it "allows logged in user to visit the structure page " do
    sign_in user
		visit binda.structures_path
		expect( page ).to have_current_path( binda.structures_path )
	end

end