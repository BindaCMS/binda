require "rails_helper"

describe "Editing a component", type: :feature do

	before(:context) do
		login_as( Binda::User.first, :scope => :user )
		@structure = FactoryGirl.create(:structure)
	end

	it "creates a new component if name is provided" do
		# remember we are using friendly id :finders
		# see https://github.com/norman/friendly_id#what-changed-in-version-50
		visit binda.new_structure_component_path( structure_id: @structure.slug )
		expect( page ).to have_current_path( binda.new_structure_component_path( structure_id: @structure.slug ) )
		# fill_in "component_name", with: "My first component"
		# click_on "Save changes"
		# component = get_components( @structure.slug ).find{ |c| c.slug == 'my-first-component' }
		# visit binda.structure_component_path( strcuture_id: @structure.slug, component_id: component.slug )
		# expect( page ).to have_content('My first component')
	end

	it "lets edit a text field" do
		skip "not implemeted yet"
	end

	it "lets add several text fields on a repeater field" do
		skip "not implemeted yet"
	end

	it "lets reorder repeater elements" do
		pending "not implemented yet"
	end

end