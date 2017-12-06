require "rails_helper"

Capybara.default_max_wait_time = 10

describe "In field group editor, user", type: :feature, js: true do
	
	let(:user) { Binda::User.first }

	before(:context) do
		@structure = create(:structure)
		create(:field_group, structure_id: @structure.id )
	end

	before(:example) do
		sign_in user
	end

# Sometime this might fail because of the following error.
# Capybara::ElementNotFound:
#        Unable to find visible field "field_group_new_field_settings__name" that is not disabled within #<Capybara::Node::Element tag="div" path="/html/body/div/div[3]/div/div/form/div/div[1]/div[3]">
#        
# Run the test again, the code it's fine, it's just an issue of Capybara with Ajax requests
	Binda::FieldSetting.get_field_classes.each do |field_class|
		it "should be able to create a #{field_class.downcase.underscore}" do
			
			field_group = @structure.field_groups.first
			path_to_field_group = binda.edit_structure_field_group_path( structure_id: @structure.slug, id: field_group.slug )

			visit path_to_field_group

			add_new__button = "#form-item--field-group-#{field_group.id}--add-new"

			find(add_new__button).click
			
			# Make sure the form item appeared
			# sleep 0.3

			field_name_input = "field_group_new_field_settings__name"
			field_name_value = "#{field_class.downcase.underscore}-test-1"
			field_type_input = "field_group_new_field_settings__field_type"

			# A script clones and changes the id of the new form item.
			# The '1' is because items gets numbered based on clicks on the 'add_new__button' link
			within "#new-form-item-1" do
				fill_in field_name_input, with: field_name_value
			end
			select_id = first("select")[:id]
			select2("#{field_class.downcase.underscore}", select_id)
			
			click_button "save"

			visit path_to_field_group

			field_group.reload

			within "#form-item-#{field_group.field_settings.first.id}" do
				expect(page).to have_field with: field_name_value 
			end
		end
	end


	Binda::FieldSetting.get_field_classes.each do |field_class|
		it "should be able to create a #{field_class.downcase} which belongs to a repeater" do
			
			field_group = @structure.field_groups.first
			repeater = field_group.field_settings.create!(field_type: "repeater", name: "parent-repeater")
			path_to_field_group = binda.edit_structure_field_group_path( structure_id: @structure.slug, id: field_group.slug )

			visit path_to_field_group
			wrapper = "#form-section--repeater-#{repeater.id}"

			# create variable to be available throughout the example
			select_id = ''
			field_name_value = ''

			within wrapper do
				find("#form-item--repeater-#{repeater.id}--add-new").click
				field_name_input = "field_group_new_field_settings__name"
				field_name_value = "#{field_class.downcase}-test-1"
				field_type_input = "field_group_new_field_settings__field_type"
				fill_in field_name_input, with: field_name_value
				select_id = first("select")[:id]
			end

			select2("#{field_class.downcase.underscore}", select_id)
			
			click_button "save"

			visit path_to_field_group

			field_group.reload
			repeater.reload

			within "#form-section--repeater-#{repeater.id}" do
				expect(page).to have_field class: "form-item--input", with: field_name_value 
			end
		end
	end

	it "should be able to update checkbox labels and values" do

		field_group = @structure.field_groups.first
		field_setting = field_group.field_settings.create!(name: 'checkbox-test', field_type: 'checkbox')
		choice = field_setting.choices.create!(label: 'foo', value: 'bar')
		path_to_field_group = binda.edit_structure_field_group_path( structure_id: @structure.slug, id: field_group.slug )

		visit path_to_field_group

		label_field = "field_group_field_settings_attributes_0_choices_attributes_0_label"
		fill_in label_field, with: "bar"

		expect(page).to have_field label_field, with: "bar"

		click_button "save"

		visit path_to_field_group

		expect(page).to have_field label_field, with: "bar"
	end

end
