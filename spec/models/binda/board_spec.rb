require 'rails_helper'

module Binda
  RSpec.describe Board, type: :model do

		it "can have multiple associations board" do
			owner_structure = create(:board_structure)
			owner =  owner_structure.board
			relation_setting = create(:relation_setting, field_group_id: owner.structure.field_groups.first.id)
			dependent_1 = create(:component)
			dependent_2 = create(:component)

			relation1 = owner.relations.create!(field_setting_id: relation_setting.id)
			relation1.dependent_components << dependent_1
			relation1.save!

			relation2 = owner.relations.create!(field_setting_id: relation_setting.id)
			relation2.dependent_components << dependent_1
			relation2.dependent_components << dependent_2
			relation2.save!

			owner.reload
			dependents = owner.get_related_components(relation_setting.slug)

			expect(dependents.length).to eq(2)
			expect(dependents.first.name).to eq(dependent_2.name)
		end

  end
end
