require 'rails_helper'

module Binda
  RSpec.describe ComponentsController, type: :controller do

    # https://content.pivotal.io/blog/writing-rails-engine-rspec-controller-tests
    routes { Binda::Engine.routes }

    let(:user){ Binda::User.first }

    before(:context) do
      @structure = create(:article_structure_with_components_and_fields)
    end

    describe "GET #index" do
      it "returns http success" do
        sign_in user
        get :index, params: { structure_id: @structure.slug }
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #show" do
      it "returns http success" do
        sign_in user
        get :show, params: { structure_id: @structure.slug, id: @structure.components.first.slug }
        expect(response).to have_http_status(:redirect)
      end
    end

    describe "GET #edit" do
      it "returns http success" do
        sign_in user
        get :edit, params: { structure_id: @structure.slug, id: @structure.components.first.slug }
        expect(response).to have_http_status(:success)
      end
    end

    describe "POST #sort_repeaters" do
      it "reorder data belonging to a component repeater" do
        skip "TODO"
        # sign_in user
        # post :sort_repeaters, { repeater: ["4", "2", "3"] }
        # expect()
        # "repeater"=>["1", "2"], "controller"=>"binda/components", "action"=>"sort_repeaters", "structure_id"=>"page", "component_id"=>"hello-1"
        # expect()
      end
    end
  end
end