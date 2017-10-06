require "rails_helper"

Capybara.default_max_wait_time = 40

describe "In field group editor, user", type: :feature, js: true do
	
	let(:user) { Binda::User.first }

	before(:context) do
		@structure = create(:structure)
		create(:field_group, structure_id: @structure.id )
	end

	Binda::FieldSetting.get_field_classes.each do |field_class|
		it "should be able to create a #{field_class.downcase}" do
			sign_in user
			
			field_group = @structure.field_groups.first
			path_to_field_group = binda.edit_structure_field_group_path( structure_id: @structure.slug, id: field_group.slug )

			visit path_to_field_group

			click_on "form-item--field-group-#{field_group.id}--add-new"
			
			field_name_input = "field_group_new_field_settings__name"
			field_name_value = "#{field_class.downcase}-test-1"
			field_type_input = "field_group_new_field_settings__field_type"
			within ".form-item" do
				fill_in field_name_input, with: field_name_value
				select "#{field_class.downcase}", from: field_type_input
			end
			
			click_button "save"

			visit path_to_field_group

			field_group.reload

			# use this to slow down Capybara, otherwise it's too quick and is not able to find field
			# find("#field_group_field_settings_attributes_0_name")

			within "#form-section--field-group-#{field_group.id}" do
				expect(page).to have_field class: "form-item--input", with: field_name_value 
			end
		end
	end


	Binda::FieldSetting.get_field_classes.each do |field_class|
		it "should be able to create a #{field_class.downcase} which belongs to a repeater" do
			sign_in user
			
			field_group = @structure.field_groups.first
			repeater = field_group.field_settings.create!(field_type: "repeater", name: "parent-repeater")
			path_to_field_group = binda.edit_structure_field_group_path( structure_id: @structure.slug, id: field_group.slug )

			visit path_to_field_group

			field_name_value = ""

			within "#form-section--repeater-#{repeater.id}" do
				click_on "form-item--repeater-#{repeater.id}--add-new"				
				field_name_input = "field_group_new_field_settings__name"
				field_name_value = "#{field_class.downcase}-test-1"
				field_type_input = "field_group_new_field_settings__field_type"
				within ".form-item" do
					fill_in field_name_input, with: field_name_value
					select "#{field_class.downcase}", from: field_type_input
				end
			end
				
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
		sign_in user

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
