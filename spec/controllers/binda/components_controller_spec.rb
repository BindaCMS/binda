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

    before(:each) do
      sign_in user
    end

    describe "GET #index" do
      it "returns http success" do
        get :index, params: { structure_id: @structure.slug }
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #show" do
      it "returns http success" do
        get :show, params: { structure_id: @structure.slug, id: @structure.components.first.slug }
        expect(response).to have_http_status(:redirect)
      end
    end

    describe "GET #edit" do
      it "returns http success" do
        get :edit, params: { structure_id: @structure.slug, id: @structure.components.first.slug }
        expect(response).to have_http_status(:success)
      end
    end
    
    describe "POST #sort_repeaters" do
      it "reorders repeaters based on position value" do

        ordered_ids = @component.repeater_ids
        shuffled_ids = ordered_ids.shuffle

        # call sort_repeaters method via post request
        post :sort_repeaters, params: { 
          "form--list-item": shuffled_ids,
          structure_id: @structure.slug,
          component_id: @component.slug 
        }
        @component.reload

        repeater_setting_id = @structure.reload.field_groups.first.field_settings.find{ |fs| fs.field_type == 'repeater'}.id
        repeaters = @component.repeaters.order('position').find_all{ |r| r.field_setting_id = repeater_setting_id }
        
        expect(repeaters.first.position).to eq(0)
        expect(repeaters.last.position).to eq(repeaters.length-1)

        first_shuffled_id = shuffled_ids[0]
        last_shuffled_id = shuffled_ids[shuffled_ids.length-1]
        expect(@component.repeaters.find(first_shuffled_id).position).to eq(0)
        expect(@component.repeaters.find(last_shuffled_id).position).to eq(@component.repeaters.length-1)
      end
    end

    describe "POST #new_repeater" do
      it "creates a new repeater with correct position" do

        initial_repeaters_length = @component.repeaters.length
        repeater_setting = FieldSetting
          .includes(:field_group)
          .where(
            binda_field_groups: { structure_id: @structure.id },
            binda_field_settings: { field_type: 'repeater', ancestry: nil }
          )
          .first

        post :new_repeater, params: { 
          repeater_setting_id: repeater_setting.id, 
          structure_id: @structure.slug, 
          component_id: @component.slug
        }
        @component.reload
        expect(@component.repeaters.order('position').length).to eq initial_repeaters_length + 1
        expect(@component.repeaters.order('position').last.position).to eq @component.repeaters.length
      end
    end


    describe "POST #sort" do
      it "reorders components based on position value" do
        # sign_in user

        # component_one = Component.where( structure_id: @structure ).order('created_at').first
        # expect( component_one.position ).to eq(1)

        # shuffle the order of the components
        # shuffle = [
        #   @structure.components[1].id,
        #   @structure.components[2].id,
        #   @structure.components[4].id,
        #   @structure.components[0].id,
        #   @structure.components[3].id,
        # ]

        # # call sort method via post request
        # post :sort, params: {
        #   component: shuffle,
        #   structure_id: @structure.slug
        # }
        # component_one.reload
        # expect( component_one.position ).to eq(3)
        skip "not implemented yet"
      end
    end

    describe "POST #update" do
      it "removes all relations which are not listed" do
        related_structure = create(:structure)
        related_component = create(:component, structure_id: related_structure.id)
        relation_setting = create(
          :relation_setting, 
          field_group_id: @structure.field_groups.first.id
        )
        relation_setting.accepted_structures << related_structure
        relation = @component.relations.find{|rel| rel.field_setting_id == relation_setting.id}
        relation.dependent_components << related_component
        relation.reload
        expect(relation.dependent_components.any?).to be true
        params = {
          id: @component.id,
          structure_id: @structure.id,
          component: { id: @component.id, relations_attributes: {} }
        }
        params[:component][:relations_attributes][relation.id] = {
          id: relation.id,
          dependent_component_ids: [""]
        }
        post :update, params: params
        relation.reload
        expect(relation.dependent_components.empty?).to be true
      end
    end
  end
end