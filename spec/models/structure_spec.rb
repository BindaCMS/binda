# require "rails_helper"

# describe "Structure", type: :model do

# 	let( :new_structure ) { Binda::Structure.new }

# 	it "cannot be saved when name is blank" do
# 		expect { new_structure.save! }.to raise_error ActiveRecord::RecordInvalid
# 	end

# 	it "has a slug by default" do
# 		new_structure.name = 'My first structure'
# 		new_structure.save!
# 		expect( new_structure.slug ).to eq 'my-first-structure'
# 	end

# end