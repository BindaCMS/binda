require "rails_helper"

describe "GET boards#edit", type: :feature, js: true do
  include CarrierWave::Test::Matchers

	let(:user){ Binda::User.first }

	before(:context) do
		@structure = create(:board_structure_with_fields)
		@board = @structure.board
	end

	before(:example) do
		sign_in user
		@path = binda.edit_structure_board_path(@structure, @board)
		visit @path
		expect(page).to have_current_path(@path)
		# make sure the ActiveRecord objects are updated with the record present n database
		@board.reload
		@structure.reload
	end

	it "allows to edit a string field" do
		# Sometimes webdriver isn't fast enough to render this page on Travis
		# We will use find('#main-content') to force Capybara to wait before executing anything
		# (with print page.body test passes)
		find('#main-content')
		
		string_setting = @structure.field_groups.first.field_settings.where(field_type: 'string').first
		string_id = @board.strings.where(field_setting_id: string_setting.id).first.id
		string_field = "board_strings_attributes_#{string_id}_content"
		string_value = 'oh my lorem'
		expect(page).to have_content(string_setting.name)
		expect(page).to have_field(string_field)
		find_field(string_field)
		fill_in string_field, with: string_value
		click_button "save"
		expect(page).to have_field(string_field)
		expect(page).to have_field(string_field, with: string_value)
	end

	it "allows to edit a string field in a repeater" do
		ids = @board.repeaters.first.string_ids
		repeater_expand_btn = "#form--list-item-#{@board.repeaters.first.id} .form-item--collapse-btn"
		find(repeater_expand_btn).click
		# wait animation
		sleep 1
		string_field = "board_repeaters_attributes_#{@board.repeaters.first.id}_strings_attributes_#{ids[ids.length-1]}_content"
		string_value = 'oh my lorem'
		find("##{string_field}")
		fill_in string_field, with: string_value
		click_button "save"
		visit @path
		find(repeater_expand_btn).click
		# wait animation
		sleep 1
		# there is something that causes a error and sleeping for a seconds seems to avoid it...
		sleep 2
		expect(page).to have_field(string_field)
		expect(page).to have_field(string_field, with: string_value)		
	end

	it "allows to create multiple new repeater items clicking the button" do
		skip "not implemeted yet"
	end

	describe "when creating a new repeater" do
		it "sets the new item as the first one (set its position as well)" do
			skip "not implemeted yet"
		end
	end

	it "allows to edit a text field" do
		skip "not implemeted yet"
	end

	it "allows to edit a text field in a repeater" do
		skip "not implemeted yet"
	end

	it "allows to edit a selection field" do
		skip "not implemeted yet"
	end

	it "allows to edit a selection field in a repeater" do
		skip "not implemeted yet"
	end

	it "allows to edit a radio field" do
		skip "not implemeted yet"
	end

	it "allows to edit a radio field in a repeater" do
		skip "not implemeted yet"
	end

	it "allows to edit a checkbox field" do
		skip "not implemeted yet"
	end

	it "allows to edit a checkbox field in a repeater" do
		skip "not implemeted yet"
	end

	it "allows to add an image to an image field and store it" do
    Binda::Image::ImageUploader.enable_processing = true
		# Create an image field setting on which will work
		image_setting = create(:image_setting, field_group_id: @structure.field_groups.first.id)
		# Refresh the page so the image field appear on the editor
		visit @path
		expect(@board.images.first.image.present?).not_to be_truthy
		field_id = "board_images_attributes_#{@board.images.where(field_setting_id: image_setting.id ).first.id}_image"
		image_name = 'test-image.jpg'
		image_path = ::Binda::Engine.root.join('spec', 'support', image_name)
		page.execute_script("document.getElementById('#{field_id}').style.zIndex = '1'")
		page.execute_script("document.getElementById('#{field_id}').style.opacity = '1'")
		page.attach_file(field_id, image_path)
		wait_for_ajax
		sleep 1 # wait for animation to complete
		@board.reload
		image = @board.images.first
		within "#fileupload-#{image.id}" do
			expect(page).to have_content image_name
		end
    if CarrierWave::Uploader::Base.storage == CarrierWave::Storage::File
      file = MiniMagick::Image.open(::Rails.root.join(image.image.path))
    else
      file = MiniMagick::Image.open(image.image.url)
    end
		within "#fileupload-#{image.id}" do
			expect( page ).to have_content file.width
		end
		visit @path
		expect( File.basename( image.image.path ) ).to eq image_name
		within "#fileupload-#{image.id}" do
			expect( page ).to have_content image_name
			expect( page ).to have_content file.width
		end
    Binda::Image::ImageUploader.enable_processing = false
	end

	it "allows to add an image to an image field in a repeater" do
		skip "not implemeted yet"
	end

	it "allows to remove an image to an image field" do
		skip "not implemeted yet"
	end

	it "allows to remove an image to an image field in a repeater" do
		skip "not implemeted yet"
	end

	it "allows to add a new repeater element" do
		# initial_repeaters_count = @board.repeaters.count
		# expect( all('.form-item--repeater-fields').count ).to eq( initial_repeaters_count )
		# click_link "form-item--repeater-#{@board.repeaters.first.field_setting.id}--add-new-button"
		# # This find method forces Capybara to wait for Ajax request
		# find "#repeater_#{@board.repeaters.pluck(:id).last}"
		# sleep 3
		# expect( all('.form-item--repeater-fields').count ).to eq( initial_repeaters_count + 1 )
		skip "not implemented yet"
	end

	it "allows to reorder repeater elements" do
		# This is pretty difficult to on a 'feature' spec, probably not reliable either
		skip "not implemented yet"
	end

	it "allows to relate a board to other ones" do
		skip "not implemented yet"
	end

	it "doesn't allow to relate a board to itself" do
		skip "not implemented yet"
	end

	it "allows to sort repeaters" do
		@structure.reload
		repeater_setting = @structure.field_groups.first.field_settings.find{|field_setting| field_setting.field_type == 'repeater' }
		# Make sure there are at least 2 repeaters
		Binda::Repeater.create([{
			fieldable_id: @board.id,
			fieldable_type: @board.class.name,
			field_setting_id: repeater_setting.id
		},{
			fieldable_id: @board.id,
			fieldable_type: @board.class.name,
			field_setting_id: repeater_setting.id			
		}])
		# Get all repeaters associated to repeater_setting and board
		repeaters_ids = Binda::Repeater.where(
			fieldable_id: @board.id,
			fieldable_type: @board.class.name,
			field_setting_id: repeater_setting.id
		).order(:position).ids
		# Once all repeaters are created visit the page
		visit @path
		# They sohuld be sorted by position
		repeaters_dom_ids = all("ul#form--list-#{repeater_setting.id} li").map{|item| item[:id]}
		expect(repeaters_dom_ids.first).to eq "form--list-item-#{repeaters_ids.first}"
		expect(repeaters_dom_ids.last).to eq "form--list-item-#{repeaters_ids.last}"
		# Enable sorting
		find("a[test-hook=\"sortable--toggle-#{repeater_setting.id}\"]").click
		# Scroll down in order to have first and last visible on viewport
		# @see http://www.rubydoc.info/gems/selenium-webdriver/Selenium/WebDriver/SearchContext#find_element-instance_method
		# Drag and drop first item to last position (you need drag_and_drop_by to move it slightly lower than last item)
		# @see http://www.rubydoc.info/gems/selenium-webdriver/Selenium%2FWebDriver%2FActionBuilder:drag_and_drop
		target = find("#form--list-#{repeater_setting.id} #form--list-item-#{repeaters_ids.first}").native
		position = find("#form--list-#{repeater_setting.id} #form--list-item-#{repeaters_ids.last} .form-item--collapsable-stack").native
		page.evaluate_script("window.scrollTo(0, document.body.scrollHeight)")
		# position.location_once_scrolled_into_view
		page.driver.browser.action
			.drag_and_drop(target, position)
			.perform
		wait_for_ajax
		# They should be sorted by new position
		repeaters_dom_ids = all("ul#form--list-#{repeater_setting.id} li").map{|item| item[:id]}
		expect(repeaters_dom_ids.last).to eq "form--list-item-#{repeaters_ids.first}"
		expect(repeaters_dom_ids.first).to eq "form--list-item-#{repeaters_ids[1]}"
	end

end