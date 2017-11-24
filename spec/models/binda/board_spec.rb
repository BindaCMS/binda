require 'rails_helper'

module Binda
  RSpec.describe Board, type: :model do

    before(:all) do
      @structure = build(:structure)
    end

    let( :new_board ) { Board.new }

		it "can have multiple associations board" do
			structure_child = create(:board_structure)
			structure_parent_1 = create(:board_structure)
			structure_parent_2 = create(:board_structure)

			board_child = structure_child.board
			board_parent_1 = structure_parent_1.board
			board_parent_2 = structure_parent_2.board

			association1 = board_child.related_fields.create!(name: "association1", slug: "slug1")
			association1.parent_related_boards << board_parent_1
			association1.save!

			association2 = board_child.related_fields.create!(name: "association2", slug: "slug2")
			association2.parent_related_boards << board_parent_2
			association2.save!

			expect(board_child.related_fields.length).to eq(2)
		end

  end
end
