require "rails_helper"

module Binda
	RSpec.describe Structure, type: :model do
		
		it "position is assigned by default upon creation" do
			first_structure = create(:structure)
			expect(first_structure.reload.position).to eq 1
		end

		it "position increments every time a new item is created" do
			first_structure = create(:structure)
			second_structure = create(:structure)
			expect(second_structure.reload.position).to eq 1
			expect(first_structure.reload.position).to eq 2
		end
	end
end