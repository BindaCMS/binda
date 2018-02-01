require "rails_helper"

Capybara.default_max_wait_time = 10

describe "GET field_groups#edit", type: :feature, js: true do
	
	let(:user) { Binda::User.first }

	before(:context) do
		@structure = create(:structure)
		create(:field_group, structure_id: @structure.id )
	end

	before(:example) do
		sign_in user
	end

	it "displays the field group editor" do 
		field_group = @structure.field_groups.first
		path_to_field_group = binda.edit_structure_field_group_path( structure_id: @structure.slug, id: field_group.slug )
		visit path_to_field_group
		expect( page ).to have_current_path(path_to_field_group)
		expect( page ).to have_selector(".form-item--editor", visible: false)
	end
end