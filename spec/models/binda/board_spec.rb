require 'rails_helper'

module Binda
  RSpec.describe Board, type: :model do

    before(:all) do
      @structure = build(:structure)
    end

    let( :new_board ) { Board.new }

		it "can have multiple parents board" do
			board_child = create(:board_structure)
			board_parent_1 = create(:board_structure)
			board_parent_2 = create(:board_structure)
			board_child.parent_fieldables << board_parent_1
			board_child.parent_fieldables << board_parent_2
			board_child.save!
			expect(board_child.parent_fieldables.length).to eq(2)
		end

  end
end
