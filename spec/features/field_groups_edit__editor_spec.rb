require 'rails_helper'

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

			wait_for_ajax
			sleep 1.2

			new_field_setting = field_group.field_settings.order('id ASC').last

			field_name_input = "field_group_field_settings_attributes_#{new_field_setting.id}_name"
			field_name_value = "Test #{new_field_setting.id}"
			field_type_input = "field_group_field_settings_attributes_#{new_field_setting.id}_field_type"

			within "#form-item-#{new_field_setting.id}" do
				fill_in field_name_input, with: field_name_value, visible: true
			end
			select2("#{field_class.downcase.underscore}", field_type_input)
			
			click_button "save"

			visit path_to_field_group

			field_group.reload

			within "#form-item-#{new_field_setting.id}" do
				find('.form-item--collapse-btn').click
				# Make sure the form item appeared
				sleep 1
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
			wrapper = "#form-item--field-list-#{repeater.id}"

			# create variable to be available throughout the example
			field_name_value = ''
			field_type_input = ''

			within wrapper do
				add_new__button = "#form-item--repeater-#{repeater.id}--add-new"
				find(add_new__button).click
				wait_for_ajax
				sleep 1.2

				new_field_setting = field_group.field_settings.order('id ASC').last

				field_name_input = "field_group_field_settings_attributes_#{new_field_setting.id}_name"
				field_name_value = "Test #{new_field_setting.id}"
				field_type_input = "field_group_field_settings_attributes_#{new_field_setting.id}_field_type"

				fill_in field_name_input, with: field_name_value
			end

			select2("#{field_class.downcase.underscore}", field_type_input)
			
			click_button "save"

			visit path_to_field_group

			field_group.reload
			repeater.reload

			within "#form-item--field-list-#{repeater.id}" do
				find('.form-item--collapse-btn').click
				# Make sure the form item appeared
				sleep 1
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
				
		within "#form-item-#{field_setting.id}" do
			find('.form-item--collapse-btn').click
			# Make sure the form item appeared
			sleep 1
		end

		label_field = "field_group_field_settings_attributes_0_choices_attributes_0_label"
		fill_in label_field, with: "bar"
			
		expect(page).to have_field label_field, with: "bar"

		click_button "save"

		visit path_to_field_group
		within "#form-item-#{field_setting.id}" do
			find('.form-item--collapse-btn').click
			# Make sure the form item appeared
			sleep 1
		end
		expect(page).to have_field label_field, with: "bar"
	end

	it "shouldn't be able to delete the only choice of a field setting if it requires at least one" do
		skip "not implemented yet"
	end

	it "shouldn't be able to delete a choice of a field setting if it requires at least one but there's more than one" do
		skip "not implemented yet"
	end

end
