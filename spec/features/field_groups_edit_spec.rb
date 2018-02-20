require "rails_helper"

Capybara.default_max_wait_time = 10

describe "GET field_groups#edit", type: :feature, js: true do
	
	let(:user) { Binda::User.first }

	before(:context) do
		@structure = create(:structure)
		@component = create(:component, structure_id: @structure.id)
		@field_group = @structure.reload.field_groups.first
		@path = binda.edit_structure_field_group_path(@structure, @field_group )
	end

	before(:example) do
		sign_in user
	end

	it "displays the field group editor" do 
		visit @path
		expect( page ).to have_current_path(@path)
		expect( page ).to have_selector(".form--list", visible: false)
	end


	it "allows to sort field settings" do
		# create at least 2 field settings
		@structure.field_groups.first.field_settings.create([
			{
				field_type: "repeater",
				name: attributes_for(:field_setting)[:name]
			},
			{
				field_type: "text",
				name: attributes_for(:field_setting)[:name]
			}
		])
		# Get all repeaters associated to field_group and component
		field_settings_ids = Binda::FieldSetting.where(
			field_group_id: @field_group.id,
			ancestry: nil
		).order(:position).ids
		# Once all repeaters are created visit the page
		visit @path
		# They sohuld be sorted by position
		field_settings_dom_ids = all("ul#form--list-#{@field_group.id} li").map{|item| item[:id]}
		expect(field_settings_dom_ids.first).to eq "form--list-item-#{field_settings_ids.first}"
		expect(field_settings_dom_ids.last).to eq "form--list-item-#{field_settings_ids.last}"
		# Enable sorting
		find("a[test-hook=\"sortable--toggle-#{@field_group.id}\"]").click
		# Scroll down in order to have first and last visible on viewport
		# @see http://www.rubydoc.info/gems/selenium-webdriver/Selenium/WebDriver/SearchContext#find_element-instance_method
		# Drag and drop first item to last position (you need drag_and_drop_by to move it slightly lower than last item)
		# @see http://www.rubydoc.info/gems/selenium-webdriver/Selenium%2FWebDriver%2FActionBuilder:drag_and_drop
		target = find("#form--list-#{@field_group.id} #form--list-item-#{field_settings_ids.first}").native
		position = find("#form--list-#{@field_group.id} #form--list-item-#{field_settings_ids.last} .form-item--collapsable-stack").native
		page.evaluate_script("window.scrollTo(0, document.body.scrollHeight)")
		# position.location_once_scrolled_into_view
		page.driver.browser.action
			.drag_and_drop(target, position)
			.drag_and_drop_by(target, 1, 80) # make sure it's dragged below the latest element
			.perform
		wait_for_ajax
		# They should be sorted by new position
		field_settings_dom_ids = all("ul#form--list-#{@field_group.id} li").map{|item| item[:id]}
		expect(field_settings_dom_ids.last).to eq "form--list-item-#{field_settings_ids.first}"
		expect(field_settings_dom_ids.first).to eq "form--list-item-#{field_settings_ids[1]}"
	end

	it "allows to sort field settings children of a repeater setting" do
		# create at least 2 field settings
		repeater_setting = create(
			:repeater_setting, 
			field_group_id: @structure.field_groups.first.id
		)
		@field_group.field_settings.create!([
			{
				field_type: "image",
				name: attributes_for(:field_setting)[:name],
				ancestry: repeater_setting.id
			},
			{
				field_type: "text",
				name: attributes_for(:field_setting)[:name],
				ancestry: repeater_setting.id
			}
		])
		# Get all repeaters associated to field_group and component
		field_settings_ids = Binda::FieldSetting.where(
			field_group_id: @field_group.id,
			ancestry: repeater_setting.id
		).order(:position).ids
		# Once all repeaters are created visit the page
		visit @path
		# They sohuld be sorted by position
		field_settings_dom_ids = all("ul#form--list-#{repeater_setting.id} li").map{|item| item[:id]}
		expect(field_settings_dom_ids.first).to eq "form--list-item-#{field_settings_ids.first}"
		expect(field_settings_dom_ids.last).to eq "form--list-item-#{field_settings_ids.last}"
		# Enable sorting
		find("a[test-hook=\"sortable--toggle-#{repeater_setting.id}\"]").click
		# Scroll down in order to have first and last visible on viewport
		# @see http://www.rubydoc.info/gems/selenium-webdriver/Selenium/WebDriver/SearchContext#find_element-instance_method
		# Drag and drop first item to last position (you need drag_and_drop_by to move it slightly lower than last item)
		# @see http://www.rubydoc.info/gems/selenium-webdriver/Selenium%2FWebDriver%2FActionBuilder:drag_and_drop
		target = find("#form--list-#{repeater_setting.id} #form--list-item-#{field_settings_ids.first}").native
		position = find("#form--list-#{repeater_setting.id} #form--list-item-#{field_settings_ids.last} .form-item--collapsable-stack").native
		page.evaluate_script("window.scrollTo(0, document.body.scrollHeight)")
		# position.location_once_scrolled_into_view
		page.driver.browser.action
			.drag_and_drop(target, position)
			.drag_and_drop_by(target, 1, 80) # make sure it's dragged below the latest element
			.perform
		wait_for_ajax
		# They should be sorted by new position
		field_settings_dom_ids = all("ul#form--list-#{repeater_setting.id} li").map{|item| item[:id]}
		expect(field_settings_dom_ids.last).to eq "form--list-item-#{field_settings_ids.first}"
		expect(field_settings_dom_ids.first).to eq "form--list-item-#{field_settings_ids[1]}"
	end

end