require 'rails_helper'

module Binda
  RSpec.describe ComponentsController, type: :controller do

    # https://content.pivotal.io/blog/writing-rails-engine-rspec-controller-tests
    routes { Binda::Engine.routes }

    let(:user){ Binda::User.first }

    before(:context) do
      @structure = create(:article_structure_with_components_and_fields)
      @component = @structure.components.first
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

    describe "POST #new_repeater" do
      it "create a new repeater with correct position" do
        sign_in user

        initial_repeaters_length = @component.repeaters.length
        repeater_setting_id = @structure.field_groups.first.field_settings.find{ |fs| fs.field_type == 'repeater'}.id

        post :new_repeater, params: { 
          repeater_setting_id: 3, 
          structure_id: @structure.slug, 
          component_id: @component.slug
        }
        @component.reload
        
        expect( @component.repeaters.order('position').length ).to eq( initial_repeaters_length + 1 )
        expect( @component.repeaters.order('position').last.position ).to eq( @component.repeaters.length )
      end
    end

    describe "POST #sort_repeaters" do
      it "reorder data belonging to a component repeater" do
        # skip "TODO"
        sign_in user
        
        post :sort_repeaters, params: { 
          repeater: ["2", "3", "1"], 
          structure_id: @structure.slug,
          component_id: @component.slug 
        }
        @component.reload

        repeater_setting_id = @structure.field_groups.first.field_settings.find{ |fs| fs.field_type == 'repeater'}.id
        repeaters = @component.repeaters.order('position').find_all{ |r| r.field_setting_id = repeater_setting_id }
        
        expect( repeaters.first.position ).not_to eq(0)
        expect( repeaters.first.position ).to eq(1)
        expect( repeaters.find{ |r| r.id == 1 }.position ).to eq(3)
      end
    end
  end
end