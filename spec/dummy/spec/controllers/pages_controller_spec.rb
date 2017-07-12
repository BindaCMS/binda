require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  describe "ApplicationController concerns" do

    before(:each) do
      @component = create(:article_component)
    end

    it "returns list of components if get_components gets called" do
      published_components = Binda::ApplicationController.new.get_components( @component.structure.slug )
      expect( published_components.length ).to eq( 0 )
      all_components = Binda::ApplicationController.new.get_components( @component.structure.slug, false )
      expect( all_components.length ).to eq( 1 )
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
