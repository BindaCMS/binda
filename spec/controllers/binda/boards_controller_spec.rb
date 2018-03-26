require 'rails_helper'

module Binda
  RSpec.describe BoardsController, type: :controller do

    # https://content.pivotal.io/blog/writing-rails-engine-rspec-controller-tests
    routes { Engine.routes }

    let(:user){ User.first }

    before(:context) do
      @structure = create(:board_structure_with_fields)
      @board = @structure.board
    end

    before(:example) do 
      sign_in user
    end

    describe "GET #show" do
      it "returns http success" do
        get :show, params: { structure_id: @structure.slug, id: @board.slug }
        expect(response).to have_http_status(:redirect)
      end
    end

    describe "GET #edit" do
      it "returns http success" do
        get :edit, params: { structure_id: @structure.slug, id: @board.slug }        
        expect(response).to have_http_status(:success)
      end
    end

 
    describe "POST #sort_repeaters" do
      it "reorder repeater based on position value" do
        @board.reload # apparently this is needed as the variable isn't updated to reflect the real record state
        ordered_ids = @board.repeater_ids
        shuffled_ids = ordered_ids.shuffle

        # call sort_repeaters method via post request
        post :sort_repeaters, params: { 
          'form--list-item': shuffled_ids,
          structure_id: @structure.slug,
          board_id: @board.slug 
        }
        @board.reload

        repeater_setting_id = @structure.reload.field_groups.first.field_settings.find{ |fs| fs.field_type == 'repeater'}.id
        repeaters = @board.repeaters.order('position').find_all{ |r| r.field_setting_id = repeater_setting_id }
        
        expect(repeaters.first.position).to eq 1
        expect(repeaters.last.position).to eq repeaters.length

        first_shuffled_id = shuffled_ids[0]
        last_shuffled_id = shuffled_ids[shuffled_ids.length-1]
        expect(@board.repeaters.find(first_shuffled_id).position).to eq 1
        expect(@board.repeaters.find(last_shuffled_id).position).to eq @board.repeaters.length
      end
    end

    describe "POST #new_repeater" do
      it "create a new repeater with correct position" do
        @board.reload # apparently this is needed as the variable isn't updated to reflect the real record state
        initial_repeaters_length = @board.repeaters.length
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
          board_id: @board.slug
        }
        @board.reload
        expect( @board.repeaters.order('position').length ).to eq( initial_repeaters_length + 1 )
        expect( @board.repeaters.order('position').last.position ).to eq( @board.repeaters.length )
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
        relation = @board.relations.find{|rel| rel.field_setting_id == relation_setting.id}
        relation.dependent_components << related_component
        relation.reload
        expect(relation.dependent_components.any?).to be true
        params = {
          id: @board.id,
          structure_id: @structure.id,
          board: { id: @board.id, relations_attributes: {} }
        }
        params[:board][:relations_attributes][relation.id] = {
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