require 'rails_helper'

module Binda
  RSpec.describe Board, type: :model do

    before(:all) do
      @structure = build(:structure)
    end

    let( :new_board ) { Board.new }

		it "can have multiple associations board" do
			board_child = create(:board_structure)
			board_parent_1 = create(:board_structure)
			board_parent_2 = create(:board_structure)

			association1 = board_child.association_fields.create!(name: "association1", slug: "slug1")
			association1.parent_fieldables_board << board_parent_1
			association1.save!

			association2 = board_child.association_fields.create!(name: "association2", slug: "slug2")
			association2.parent_fieldables_board << board_parent_2
			association2.save!

			expect(board_child.association_fields.length).to eq(2)
		end

  end
end
