require "rails_helper"

# Include Devise Helper
# https://github.com/plataformatec/devise/wiki/How-To:-Test-with-Capybara
include Warden::Test::Helpers

describe "When use modifies the structures,", type: :feature do
	it "redirects user if he isn't logged in" do
		visit binda.structures_path
		expect(page).not_to have_current_path( binda.structures_path )
	end

	it "allows logged in user to visit structure page if " do
		user = FactoryGirl.create(:user)
		login_as(user, :scope => :user)
		visit binda.structures_path
		expect(page).to have_current_path( binda.structures_path )
	end

end