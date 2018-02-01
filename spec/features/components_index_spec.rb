require 'rails_helper'

describe "GET components#index", type: :feature, js: true do
	
	let(:user) { Binda::User.first }

	before(:context) do
		@structure = create(:structure, instance_type: 'component')
		for i in 1..3
			create(:component, structure_id: @structure.id)
		end
	end

	before(:example) do
		sign_in user
		path = binda.structure_components_path(@structure)
		visit path
		expect(page).to have_current_path(path)
	end

	it "shows a list of components" do
		component_names = @structure.components.order('name ASC').map(&:name)
		expect(page).to have_content(component_names.first)
		expect(page).to have_content(component_names.last)
	end

	it "shows a list of components in alphabetical order" do
		component_names = @structure.components.order('name ASC').map(&:name)
		expect(page.body.index(component_names.first)).to be < page.body.index(component_names.last)
	end

	it "displays only components withing the current pagination" do
		# Keep the deafult pagination in order to restore it later
		default_pagination = Binda::Component.default_per_page
		# Low the number of component per page so one is left out
		visit binda.structure_components_path(@structure, { page: @structure.components.length - 1 })
		component_names = @structure.components.order('name ASC').map(&:name)
		expect(page).not_to have_content(component_names.last)
	end

end