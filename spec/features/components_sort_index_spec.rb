require "rails_helper"

describe "GET components#sort_index:", type: :feature, js: true do
	let(:user) { Binda::User.first }

	before(:context) do
		@structure = create(:article_structure_with_components)
	end
	
	before(:example) do
		sign_in user
	end

	it "displays components sorted by position" do
		first_component = @structure.components.order(:position).first
		first_position = first_component.position
		last_component = @structure.components.order(:position).last
		last_position = last_component.position

		path = binda.structure_components_sort_index_path( structure_id: @structure.id ) 
		visit path
		expect(page).to have_current_path(path)
		expect(page.body.index(first_component.name)).to be < page.body.index(last_component.name) 

		first_component.update_attribute('position', last_position)
		last_component.update_attribute('position', first_position)

		first_component.reload
		last_component.reload

		visit path
		expect(page.body.index(first_component.name)).to be > page.body.index(last_component.name)
	end
end