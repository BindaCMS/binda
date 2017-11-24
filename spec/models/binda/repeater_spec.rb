require 'rails_helper'

module Binda
  RSpec.describe Board, type: :model do

    before(:all) do
      @structure = build(:structure)
    end

    let( :new_board ) { Board.new }

    it "can have multiple parents repeater" do

      component = create(:component)
      field_setting = create(:field_setting, field_group_id: component.structure.field_groups.first.id, field_type: "repeater")

      repeater_child = component.repeaters.create!(field_setting_id: field_setting.id)
      repeater_parent_1 = component.repeaters.create!(field_setting_id: field_setting.id)
      repeater_parent_2 = component.repeaters.create!(field_setting_id: field_setting.id)

      repeater_child.parent_fieldables << repeater_parent_1
      repeater_child.parent_fieldables << repeater_parent_2
      repeater_child.save!
      expect(repeater_child.parent_fieldables.length).to eq(2)
    end

  end
end
