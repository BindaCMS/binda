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
	#        Unable to find visible field "field_group_field_settings__name" that is not disabled within #<Capybara::Node::Element tag="div" path="/html/body/div/div[3]/div/div/form/div/div[1]/div[3]">
	#        
	# Run the test again, the code it's fine, it's just an issue of Capybara with Ajax requests
	Binda::FieldSetting.get_field_classes.each do |field_class|

		it "is able to create a #{field_class.downcase.underscore}" do
			field_group = @structure.field_groups.first
			path_to_field_group = binda.edit_structure_field_group_path( structure_id: @structure.slug, id: field_group.slug )

			visit path_to_field_group

			add_new__button = "#form--list-#{field_group.id}--add-list-item"
			find(add_new__button).click
			wait_for_ajax
			sleep 1.2

			new_field_setting = field_group.reload.field_settings.order('id ASC').last

			field_name_id = find('.form-item--default-input')[:id]
			field_name_value = "Test #{new_field_setting.id}"
			field_type_id = find('.form-item--select-input')[:id]

			within "#form--list-item-#{new_field_setting.id}" do
				fill_in field_name_id, with: field_name_value, visible: true
			end
			select2("#{field_class.downcase.underscore}", field_type_id )
			
			click_button "save"

			visit path_to_field_group

			field_group.reload

			within "#form--list-item-#{new_field_setting.id}" do
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
			repeater_setting = field_group.field_settings.create!(field_type: "repeater", name: "parent-repeater")
			path_to_field_group = binda.edit_structure_field_group_path( structure_id: @structure.slug, id: field_group.slug )

			visit path_to_field_group
			wrapper = "#form--list-#{repeater_setting.id}"

			# create variable to be available throughout the example
			field_name_value = ''
			field_type_input = ''
			field_type_id = ''

			add_new__button = "#form--list-#{repeater_setting.id}--add-list-item"
			find(add_new__button).click
			wait_for_ajax
			sleep 1.2

			within wrapper do
				field_name_id = find('.form-item--default-input')[:id]
				field_name_value = "Test #{repeater_setting.id}"
				field_type_id = find('.form-item--select-input')[:id]

				fill_in field_name_id, with: field_name_value, visible: true
			end
			select2("#{field_class.downcase.underscore}", field_type_id )
			
			click_button "save"

			visit path_to_field_group

			field_group.reload
			field_setting_child = field_group.field_settings.where.not(ancestry:nil).first

			within "#form--list-item-#{field_setting_child.id}" do
				find('.form-item--collapse-btn').click
				
				# find(:xpath, './/a[@class="form-item--collapse-btn"]').click
				# binding.pry
				# see https://stackoverflow.com/questions/32984498/rails-4-adding-child-index-to-dynamically-added-nested-form-fields-with-cocoo
				
				field_name_id_reloaded = find('.form-item--default-input')[:id]
				# Make sure the form item appeared
				sleep 1
				expect(page).to have_field field_name_id_reloaded, with: field_name_value 
			end
		end
	end

	it "should be able to update checkbox labels and values" do

		field_group = @structure.field_groups.first
		field_setting = field_group.field_settings.create!(name: 'checkbox-test', field_type: 'checkbox')
		choice = field_setting.choices.create!(label: 'foo', value: 'bar')
		path_to_field_group = binda.edit_structure_field_group_path( structure_id: @structure.slug, id: field_group.slug )

		visit path_to_field_group
				
		within "#form--list-item-#{field_setting.id}" do
			find('.form-item--collapse-btn').click
			# Make sure the form item appeared
			sleep 1
		end

		label_field = "field_group_field_settings_attributes_0_choices_attributes_0_label"
		fill_in label_field, with: "bar"
			
		expect(page).to have_field label_field, with: "bar"

		click_button "save"

		visit path_to_field_group
		within "#form--list-item-#{field_setting.id}" do
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
