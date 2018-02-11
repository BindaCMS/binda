require "rails_helper"

describe "GET component#edit", type: :feature, js: true do
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
		# make sure the ActiveRecord object (@board) is updated with the real state of the board
		@board.reload
	end

	it "allows to edit a string field" do
		string_setting = @structure.field_groups.first.field_settings.where(field_type: 'string').first

		string_id = @board.strings.where(field_setting_id: string_setting.id).first.id

		string_field = "board_strings_attributes_#{string_id}_content"
		string_value = 'oh my lorem'

		find("##{string_field}")

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
		
		# wait animation
		sleep 1

		find(repeater_expand_btn).click
		# wait animation
		sleep 1

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

	it "should not be possible to relate a board to itself" do
		skip "not implemented yet"
	end

end