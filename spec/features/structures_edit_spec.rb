require "rails_helper"

describe "GET structures#edit", type: :feature, js: true do

	let(:user){ Binda::User.first }

	before(:context) do
		@structure = create(:structure)
		create(:field_group, structure_id: @structure.id )
	end

	before(:example) do
		sign_in user
		path_to_structure = binda.edit_structure_path( @structure.slug )
		visit path_to_structure
		expect( page ).to have_current_path( path_to_structure )
	end

	it "shows field groups which belong to the current structure" do
		field_groups = @structure.field_groups.order(:position)
		expect(page.body.index(field_groups.first.name)).to be < page.body.index(field_groups.last.name)
	end

	it "creates a new structure if name is provided" do
		find('a[test-hook="new-structure-btn"]').click
		expect(page).to have_current_path(binda.new_structure_path)
	end

	it "lets you add new field groups" do
		skip "not implemented yet"
	end

end