require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  describe "ApplicationController concerns" do

    it "returns list of components if get_components gets called" do
      published_components = controller.get_components( 'page' )
      expect( published_components.length ).to eq( 0 )
      all_components = controller.get_components( 'page', { published: false } )
      expect( all_components.length ).to eq( Binda::Structure.where(slug: 'page').first.components.length )
    end
  end

  # describe "GET #index" do
  #   it "returns http success" do
  #     get :index
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET #show" do
  #   it "returns http success" do
  #     get :show
  #     expect(response).to have_http_status(:success)
  #   end
  # end

end
