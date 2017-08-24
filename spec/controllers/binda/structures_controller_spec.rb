require 'rails_helper'

module Binda
	RSpec.describe StructuresController, type: :controller do

		# https://content.pivotal.io/blog/writing-rails-engine-rspec-controller-tests
		routes { Engine.routes }

		let(:user){ User.first }

		describe "GET #index" do
			it "retruns http success" do
				sign_in user
				# login_as( user, :scope => :user )
				get :index
				expect(response).to have_http_status(:success)
			end
		end

	end
end