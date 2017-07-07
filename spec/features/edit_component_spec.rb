require "rails_helper"

describe "Editing component:", type: :feature do

	let(:user){ Binda::User.first }

	before(:each) do
		@structure = create(:structure)
	end

	it "fails if you try to create a component with no name" do
		login_as( user, :scope => :user )
		visit binda.new_structure_component_path( structure_id: @structure.slug )
		expect( page ).to have_current_path( binda.new_structure_component_path( structure_id: @structure.slug ) )
		previous_components_quantity = @structure.components.length
		click_button "Save changes"
		current_components_quantity = @structure.components.length
		expect( current_components_quantity ).to eq( previous_components_quantity )
	end

	it "creates a new component if name is provided" do
		login_as( user, :scope => :user )
		visit binda.new_structure_component_path( structure_id: @structure.slug )
		expect( page ).to have_current_path( binda.new_structure_component_path( structure_id: @structure.slug ) )
		fill_in "component_name", with: "Hello"
		expect(page).to have_selector "#component_name[value='Hello']"
		click_button "Save changes"
		expect( page ).not_to have_content "You need to create the component before being able to add any detail"
	end

	it "lets edit a text field" do
		skip "not implemeted yet"
	end

	it "lets add several text fields on a repeater field" do
		skip "not implemeted yet"
	end

	it "lets reorder repeater elements" do
		skip "not implemented yet"
	end

end