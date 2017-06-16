require "rails_helper"

describe "User session", type: :feature do

	it "redirects to login if user isn't logged in" do
		visit binda.structures_path
		expect(page).not_to have_current_path( binda.structures_path )
	end

	it "allows logged in user to visit the structure page " do
		user = FactoryGirl.create(:user)
		login_as(user, :scope => :user)
		visit binda.structures_path
		expect(page).to have_current_path( binda.structures_path )
	end

end