require "rails_helper"

describe "Field group", type: :feature do
	
	let(:user) { Binda::User.first }

	before(:context) do
		@structure = create(:structure)
		# create at two field groups for that structure
		create(:field_group, structure_id: @structure.id )
		create(:field_group, structure_id: @structure.id )
	end

	it "should be listed on the structure page to which it belongs" do
		sign_in user
		path_to_structure = binda.edit_structure_path( @structure.slug )
		visit path_to_structure
		expect( page ).to have_current_path( path_to_structure )
		field_groups = @structure.field_groups.order( :position )
		expect( page.body.index( field_groups.first.name ) ).to be < page.body.index( field_groups.last.name )
	end

	it "should display an editor with its field settings" do 
		sign_in user
		field_group = @structure.field_groups.first
		path_to_field_group = binda.edit_structure_field_group_path( structure_id: @structure.slug, id: field_group.slug )
		visit path_to_field_group
		expect( page ).to have_current_path( path_to_field_group )
		expect( page ).to have_selector( ".form-item--editor" )
	end

	describe "if user wants to modify a checkbox" do
		it "should let user update labels and values" do
			sign_in user

			field_group = @structure.field_groups.first
			field_setting = field_group.field_settings.create!(name: 'checkbox-test', field_type: 'checkbox')
			choice = field_setting.choices.create!(label: 'foo', value: 'bar')
			path_to_field_group = binda.edit_structure_field_group_path( structure_id: @structure.slug, id: field_group.slug )

			visit path_to_field_group

			label_field = "field_group_field_settings_attributes_0_choices_attributes_0_label"

			find("##{label_field}")

			expect(page).to have_selector("##{label_field}")

			fill_in label_field, with: 'bar'
			click_button "save"

			visit path_to_field_group

			expect(page).to have_field(label_field)
			expect(page).to have_field(label_field, with: 'bar')
		end
	end

end
