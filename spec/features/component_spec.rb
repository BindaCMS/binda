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

		path = binda.structure_components_path( structure_id: @structure.id ) 
		visit path
		expect( page ).to have_current_path( path )
		expect( page.body.index( first_component.name ) ).to be < page.body.index( last_component.name ) 

		first_component.update_attribute( 'position', last_position )
		last_component.update_attribute( 'position', first_position )

		first_component.reload
		last_component.reload

		visit path
		expect( page.body.index( first_component.name ) ).to be > page.body.index( last_component.name )
	end
end

describe "Editing component:", type: :feature, js: true do

	let(:user){ Binda::User.first }

	before(:context) do
		@structure = create(:article_structure_with_components_and_fields)
		@component = @structure.components.first
	end

	it "fails if you try to create a component with no name" do
    sign_in user
    path = binda.new_structure_component_path( structure_id: @structure.slug )
		visit path
		expect( page ).to have_current_path( path )
		previous_components_quantity = @structure.components.length
		click_button "form-body--save"
		current_components_quantity = @structure.components.length
		expect( current_components_quantity ).to eq( previous_components_quantity )
	end

	it "creates a new component if name is provided" do
    sign_in user
    path = binda.new_structure_component_path( structure_id: @structure.slug )
		visit path
		expect( page ).to have_current_path( path )
		string_value = 'hello'
		fill_in "component_name", with: 'hello'
		expect( find('#component_name').value ).to eq string_value
		click_button "form-body--save"
		# @todo this should be changed
		expect( page ).not_to have_content "You need to create the component before being able to add any detail"
		expect( Binda::Component.where( structure_id: @structure, name: string_value ).count ).to eq 1
	end

	it "isn't blocked by any Rails error" do
		sign_in user
		path = binda.edit_structure_component_path( structure_id: @structure.slug, id: @component.slug ) 
		visit path
		expect( page ).to have_current_path( path )
		expect( page ).to have_selector "#component_name[value='#{ @component.name }']"
	end

	it "lets edit a string field" do
		sign_in user
		path = binda.edit_structure_component_path( @structure, @component )
		visit path
		expect( page ).to have_current_path( path )
		string_field = "component_strings_attributes_#{@component.string_ids.first}_content"
		string_value = 'oh my lorem'
		fill_in string_field, with: string_value
		click_button "form-body--save"
		expect( find( "##{string_field}" ).value ).to eq string_value
		expect( @component.strings.first.content ).to eq string_value
	end

	it "lets edit a string field in a repeater" do
		sign_in user
		path = binda.edit_structure_component_path( @structure, @component )
		visit path
		expect( page ).to have_current_path( path )
		string_field = "component_repeaters_attributes_#{@component.repeater_ids.first}_strings_attributes_#{@component.repeaters.first.string_ids.first}_content"
		string_value = 'oh my lorem'
		fill_in string_field, with: string_value
		click_button "form-body--save"
		expect( find( "##{string_field}" ).value ).to eq string_value
		expect( @component.repeaters.first.strings.first.content ).to eq string_value
	end

	it "lets edit a text field" do
		skip "not implemeted yet"
	end

	it "lets edit a text field in a repeater" do
		skip "not implemeted yet"
	end

	it "lets edit a selection field" do
		skip "not implemeted yet"
	end

	it "lets edit a selection field in a repeater" do
		skip "not implemeted yet"
	end

	it "lets edit a radio field" do
		skip "not implemeted yet"
	end

	it "lets edit a radio field in a repeater" do
		skip "not implemeted yet"
	end

	it "lets edit a checkbox field" do
		skip "not implemeted yet"
	end

	it "lets edit a checkbox field in a repeater" do
		skip "not implemeted yet"
	end

	it "lets add an image to an asset field" do
		skip "not implemeted yet"
	end

	it "lets add an image to an asset field in a repeater" do
		skip "not implemeted yet"
	end

	it "lets remove an image to an asset field" do
		skip "not implemeted yet"
	end

	it "lets remove an image to an asset field in a repeater" do
		skip "not implemeted yet"
	end

	it "lets add a new repeater element" do
		sign_in user
		path = binda.edit_structure_component_path( @structure, @component )
		visit path
		expect( page ).to have_current_path( path )
		initial_repeaters_count = @component.repeaters.count
		expect( all('.form-item--repeater-fields').count ).to eq( initial_repeaters_count )
		click_link "form-item--repeater-#{@component.repeaters.first.field_setting.id}--add-new-button"
		# This find method forces Capybara to wait for Ajax request
		find "#repeater_#{@component.repeaters.pluck(:id).last}"
		expect( all('.form-item--repeater-fields').count ).to eq( initial_repeaters_count + 1 )
	end

	it "lets reorder repeater elements" do
		# This is pretty difficult, probably not reliable either
		skip "not implemented yet"
	end

end