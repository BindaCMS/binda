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

	it "displays a flash alert on critical error like: require a selection field to have at least a choice when there's none" do
		# Make sure there is no alert before generating the error
		visit binda.structure_components_path(@structure)
		expect(page).not_to have_selector('div[test-hook="critical-alert"]')

		# Create premises for the error:
		# Create a radio setting which by default has allow_null=false, but then do create any default choice
		radio_setting = create(:radio_setting, field_group_id: @structure.field_groups.first.id)

		# Make sure there is no alert before generating the error
		visit binda.structure_components_path(@structure)
		expect(page).to have_selector('div[test-hook="critical-alert"]')
	end

	it "displays a flash alert on critical error like: require a selection field to have at least a choice when all choices have been deleted" do
		# Create premises for the error:
		# 1. Create a radio setting which by default has allow_null=false
		radio_setting = create(:radio_setting, field_group_id: @structure.field_groups.first.id)
		# 2. Create a choice
		first_choice = radio_setting.choices.create(label: 'First', value: 'first')
		# 3. Get the radio field related to the first component
		# Binda::Component.where(structure_id: @structure.id).ids.first --> it should be faster as it shouldn't generate a query when inside a '.where'
		radio = Binda::Radio.where(
			fieldable_id: Binda::Component.where(structure_id: @structure.id).ids.first,
			field_setting_id: radio_setting.id
		).first
		
		radio.choices << first_choice
		radio.save
		radio.reload
		# 4. Make sure radio has the choice
		expect(radio.choices.first.id).to eq radio_setting.choices.first.id
		
		# Make sure there is no alert before generating the error
		visit binda.structure_components_path(@structure)
		expect(page).not_to have_selector('div[test-hook="critical-alert"]')

		# Genereate the error
		radio_setting.choices.each do |choice|
			choice.destroy
		end

		# Check if the alert is displayed correctly
		visit binda.structure_components_path(@structure)
		expect(page).to have_selector('div[test-hook="critical-alert"]')
	end

end