require 'rails_helper'

module Binda
  RSpec.describe Repeater, type: :model do

  	before(:context) do
			@structure = create(:structure)
  	end

  	it "requires to be associated to a fieldable item" do
  		
  	end

  	it "requires to be associated to a field setting" do
  	end

		describe "after has been created" do

			it "generates all its fields instances" do
				repeater_setting = create(:repeater_setting, field_group_id: @structure.field_groups.first.id)
				text_setting = create(
					:text_setting, 
					field_group_id: @structure.field_groups.first.id, 
					ancestry: repeater_setting.id
				)
				component = create(:component, structure_id: @structure.id)
				repeater = create(
					:repeater, 
					fieldable_id: component.id,
					fieldable_type: component.class.name,
					field_setting_id: repeater_setting.id
				)
				repeater.reload
				expect(repeater.texts.any?).to be true
				expect(repeater.texts.first.field_setting_id).to eq text_setting.id
			end

			it "position is assigned by default upon creation" do
				first_repeater = create(
					:repeater, 
					fieldable_id: create(:component, structure_id: @structure.id).id, 
					fieldable_type: "Binda::Component"
				)
				expect(first_repeater.reload.position).to eq 1
			end

			it "position increments every time a new item is created" do
				first_repeater = create(
					:repeater,
					fieldable_id: create(:component, structure_id: @structure.id).id, 
					fieldable_type: "Binda::Component"
				)
				second_repeater = create(
					:repeater, 
					field_setting_id: first_repeater.field_setting.id,
					fieldable_id: first_repeater.fieldable_id,
					fieldable_type: first_repeater.fieldable_type
				)
				expect(second_repeater.reload.position).to eq 1
				expect(first_repeater.reload.position).to eq 2
			end			
		end
  end
end
