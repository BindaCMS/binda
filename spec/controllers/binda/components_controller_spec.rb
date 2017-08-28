require 'rails_helper'

module Binda
  RSpec.describe ComponentsController, type: :controller do

    # https://content.pivotal.io/blog/writing-rails-engine-rspec-controller-tests
    routes { Engine.routes }

    let(:user){ User.first }

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
    
    describe "POST #sort_repeaters" do
      it "reorder repeater based on position value" do
        sign_in user

        # shuffle the order of the component repeaters
        shuffle = [
          @component.repeaters[2].id,
          @component.repeaters[0].id,
          @component.repeaters[1].id
        ]

        # call sort_repeaters method via post request
        post :sort_repeaters, params: { 
          repeater: shuffle,
          structure_id: @structure.slug,
          component_id: @component.slug 
        }
        @component.reload

        repeater_setting_id = @structure.field_groups.first.field_settings.find{ |fs| fs.field_type == 'repeater'}.id
        repeaters = @component.repeaters.order('position').find_all{ |r| r.field_setting_id = repeater_setting_id }
        
        expect( repeaters.first.position ).not_to eq(0)
        expect( repeaters.first.position ).to eq(1)
        expect( @component.repeaters[1].position ).to eq( @component.repeaters.count )
      end
    end

    describe "POST #new_repeater" do
      it "create a new repeater with correct position" do
        sign_in user

        initial_repeaters_length = @component.repeaters.length
        repeater_setting_id = @structure.field_groups.first.field_settings.find{ |fs| fs.field_type == 'repeater'}.id

        post :new_repeater, params: { 
          repeater_setting_id: repeater_setting_id, 
          structure_id: @structure.slug, 
          component_id: @component.slug
        }
        @component.reload
        expect( @component.repeaters.order('position').length ).to eq( initial_repeaters_length + 1 )
        expect( @component.repeaters.order('position').last.position ).to eq( @component.repeaters.length )
      end
    end


    describe "POST #sort" do
      it "reorder components based on position value" do
        sign_in user

        component_one = Component.where( structure_id: @structure ).order('created_at').first
        expect( component_one.position ).to eq(1)

        # shuffle the order of the components
        shuffle = [
          @structure.components[1].id,
          @structure.components[2].id,
          @structure.components[4].id,
          @structure.components[0].id,
          @structure.components[3].id,
        ]

        # call sort method via post request
        post :sort, params: {
          component: shuffle,
          structure_id: @structure.slug
        }
        component_one.reload
        expect( component_one.position ).to eq(3)
      end
    end
  end
end