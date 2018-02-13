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

	it "allows to add new field groups" do
		num_of_groups = all("#form--list-#{@structure.id} li").length
		find('.form--add-list-item').click
		wait_for_ajax
		# wait for animation
		sleep 1
		expect(all("#form--list-#{@structure.id} li").length).to eq(num_of_groups+1)
	end

	# there was a subtle but very irritating error which this test make sure won't happen again
	it "allows to destroy a field group and the save the structure" do
		find('.form--add-list-item').click
		wait_for_ajax
		# wait for animation
		sleep 1
		id = @structure.reload.field_groups.order('created_at ASC').last.id
		expect(page).to have_selector("#form--list-item-#{id}")
		accept_alert do
			find("#form--list-item-#{id} .form--delete-list-item").click
		end
		wait_for_ajax
		# wait for animation
		sleep 1
		click_button "save"
		# look for anything, just to make sure the page isn't throwing a error
		expect(page).to have_content(@structure.name)
	end

	describe "for a specific field group" do
		it "lets edit a name of a field setting" do
			pending("Not implemented yet")
		end
		it "lets edit a slug of a field setting" do
			pending("Not implemented yet")
		end
	end
end