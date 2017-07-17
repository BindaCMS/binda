require "rails_helper"

describe "Indexing components:", type: :feature do
	let(:user) { Binda::User.first }

	before(:context) do
		@structure = create(:article_structure_with_components)
	end

	it "reorder components based on position" do
		sign_in user

		first_component = @structure.components.order(:position).first
		first_position = first_component.position
		last_component = @structure.components.order(:position).last
		last_position = last_component.position

		visit binda.structure_components_path( structure_id: @structure.id )
		expect( page ).to have_current_path( binda.structure_components_path( structure_id: @structure.id ) )
		expect( page.body.index( first_component.name ) ).to be < page.body.index( last_component.name ) 

		first_component.update_attribute( 'position', last_position )
		last_component.update_attribute( 'position', first_position )

		first_component.reload
		last_component.reload

		visit binda.structure_components_path( structure_id: @structure.id )
		expect( page.body.index( first_component.name ) ).to be > page.body.index( last_component.name ) 

	end

end

describe "Editing component:", type: :feature do

	let(:user){ Binda::User.first }

	before(:context) do
		@structure = create(:article_structure_with_components_and_fields)
		@component = @structure.components.first
	end

	it "fails if you try to create a component with no name" do
    sign_in user
		visit binda.new_structure_component_path( structure_id: @structure.slug )
		expect( page ).to have_current_path( binda.new_structure_component_path( structure_id: @structure.slug ) )
		previous_components_quantity = @structure.components.length
		click_button "Save changes"
		current_components_quantity = @structure.components.length
		expect( current_components_quantity ).to eq( previous_components_quantity )
	end

	it "creates a new component if name is provided" do
    sign_in user
		visit binda.new_structure_component_path( structure_id: @structure.slug )
		expect( page ).to have_current_path( binda.new_structure_component_path( structure_id: @structure.slug ) )
		fill_in "component_name", with: "Hello"
		expect(page).to have_selector "#component_name[value='Hello']"
		click_button "Save changes"
		expect( page ).not_to have_content "You need to create the component before being able to add any detail"
	end

	it "isn't blocked by any rails error" do
		sign_in user
		visit binda.edit_structure_component_path( structure_id: @structure.slug, id: @component.slug )
		expect( page ).to have_current_path( binda.edit_structure_component_path( structure_id: @structure.slug, id: @component.slug ) )
		expect( page ).to have_selector "#component_name[value='#{ @component.name }']"
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