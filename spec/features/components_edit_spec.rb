require "rails_helper"

describe "GET component#edit", type: :feature, js: true do
  include CarrierWave::Test::Matchers

	let(:user){ Binda::User.first }

	before(:context) do
		@structure = create(:article_structure_with_components_and_fields)
		@component = @structure.components.first
	end

	before(:example) do
		sign_in user
		@path = binda.edit_structure_component_path(@structure, @component)
		visit @path
		expect(page).to have_current_path(@path)
		# make sure the ActiveRecord object (@component) is updated with the real state of the component
		@component.reload
		@structure.reload
	end

	it "allows to edit a string field" do
		string_setting = @structure.field_groups.first.field_settings.where(field_type: 'string').first
		string_id = @component.strings.where(field_setting_id: string_setting.id).first.id
		string_field = "component_strings_attributes_#{string_id}_content"
		string_value = 'oh my lorem'
		find("##{string_field}")
		fill_in string_field, with: string_value
		click_button "save"
		expect(page).to have_field(string_field)
		expect(page).to have_field(string_field, with: string_value)
	end

	it "allows to edit a string field in a repeater" do
		ids = @component.repeaters.first.string_ids
		repeater_expand_btn = "#form--list-item-#{@component.repeaters.first.id} .form-item--collapse-btn"
		find(repeater_expand_btn).click
		# wait animation
		sleep 1
		string_field = "component_repeaters_attributes_#{@component.repeaters.first.id}_strings_attributes_#{ids[ids.length-1]}_content"
		string_value = 'oh my lorem'
		find("##{string_field}")
		fill_in string_field, with: string_value
		click_button "save"
		visit @path
		find(repeater_expand_btn).click
		# wait animation
		sleep 1
		expect(page).to have_field(string_field)
		expect(page).to have_field(string_field, with: string_value)		
	end

	# there was a subtle but very irritating error which this test make sure won't happen again
	it "allows to destroy a field and the save the component" do
		repeater_setting = @component.repeaters.first.field_setting
		find("#standard-form--repeater-#{repeater_setting.id} .form--add-list-item").click
		wait_for_ajax
		# wait for animation
		sleep 1
		id = @component.reload.repeaters.order('created_at ASC').last.id
		expect(page).to have_selector("#form--list-item-#{id}")
		accept_alert do
			find("#form--list-item-#{id} .form--delete-list-item").click
		end
		wait_for_ajax
		# wait for animation
		sleep 1
		click_button "save"
		# look for anything, just to make sure the page isn't throwing a error
		expect(page).to have_field("component_name", with: @component.name)
	end

	it "allows to create multiple new repeater items clicking the button" do		
		repeater_setting = @component.repeaters.first.field_setting
		num_of_repeaters = Binda::Repeater.where(
			field_setting_id: repeater_setting.id,
			fieldable_id: @component.id,
			fieldable_type: @component.class.name
		).length
		expect(all("#form--list-#{repeater_setting.id} li").length).to eq(num_of_repeaters)
		find("#standard-form--repeater-#{repeater_setting.id} .form--add-list-item").click
		wait_for_ajax
		# wait for animation
		sleep 1
		find("#standard-form--repeater-#{repeater_setting.id} .form--add-list-item").click
		wait_for_ajax
		# wait for animation
		sleep 1
		expect(all("#form--list-#{repeater_setting.id} li").length).to eq(num_of_repeaters+2)
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

	it "allows to upload a file to the an image field and store it" do
    Binda::Image::ImageUploader.enable_processing = true
		# Create an image field setting on which will work
		image_setting = create(:image_setting, field_group_id: @structure.field_groups.first.id)
		# Refresh the page so the image field appear on the editor
		visit @path
		expect(@component.images.first.image.present?).not_to be_truthy
		field_id = "component_images_attributes_#{@component.images.where(field_setting_id: image_setting.id ).first.id}_image"
		image_name = 'test-image.jpg'
		image_path = ::Binda::Engine.root.join('spec', 'support', image_name)
		page.execute_script("document.getElementById('#{field_id}').style.zIndex = '1'")
		page.execute_script("document.getElementById('#{field_id}').style.opacity = '1'")
		page.attach_file(field_id, image_path)
		wait_for_ajax
		sleep 1 # wait for animation to complete
		@component.reload
		image = @component.images.first
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

	it "allows to upload a file to the audio field and store it" do
    Binda::Audio::AudioUploader.enable_processing = true
		# Create an image field setting on which will work
		audio_setting = create(:audio_setting, field_group_id: @structure.field_groups.first.id)
		# Refresh the page so the image field appear on the editor
		visit @path
		expect(@component.audios.first.audio.present?).not_to be_truthy
		field_id = "component_audios_attributes_#{@component.audios.where(field_setting_id: audio_setting.id ).first.id}_audio"
		audio_name = 'test-audio.mp3'
		audio_path = ::Binda::Engine.root.join('spec', 'support', audio_name)
		page.execute_script("document.getElementById('#{field_id}').style.zIndex = '1'")
		page.execute_script("document.getElementById('#{field_id}').style.opacity = '1'")
		page.attach_file(field_id, audio_path)
		wait_for_ajax
		sleep 1 # wait for animation to complete
		@component.reload
		audio = @component.audios.first
		within "#fileupload-#{audio.id}" do
			expect(page).to have_content audio_name
			expect(page).to have_content (audio.file_size.to_f / 1.megabyte).round(2)
		end
		visit @path
		expect( File.basename( audio.audio.path ) ).to eq audio_name
		within "#fileupload-#{audio.id}" do
			expect(page).to have_content audio_name
			expect(page).to have_content (audio.file_size.to_f / 1.megabyte).round(2)
		end
    Binda::Audio::AudioUploader.enable_processing = false
	end


	it "allows to upload a file to the svg field and store it" do
    Binda::SvgUploader.enable_processing = true
		# Create an image field setting on which will work
		svg_setting = create(:svg_setting, field_group_id: @structure.field_groups.first.id)
		# Refresh the page so the image field appear on the editor
		visit @path
		expect(@component.svgs.first.svg.present?).not_to be_truthy
		field_id = "component_svgs_attributes_#{@component.svgs.where(field_setting_id: svg_setting.id ).first.id}_svg"
		svg_name = 'test-svg.svg'
		svg_path = ::Binda::Engine.root.join('spec', 'support', svg_name)
		page.execute_script("document.getElementById('#{field_id}').style.zIndex = '1'")
		page.execute_script("document.getElementById('#{field_id}').style.opacity = '1'")
		page.attach_file(field_id, svg_path)
		wait_for_ajax
		sleep 1 # wait for animation to complete
		@component.reload
		svg = @component.svgs.first
		within "#fileupload-#{svg.id}" do
			expect(page).to have_content svg_name
			expect(page).to have_content (svg.file_size.to_f / 1.megabyte).round(2)
		end
		visit @path
		expect( File.basename( svg.svg.path ) ).to eq svg_name
		within "#fileupload-#{audio.id}" do
			expect(page).to have_content svg_name
			expect(page).to have_content (svg.file_size.to_f / 1.megabyte).round(2)
		end
    Binda::SvgUploader.enable_processing = false
	end

	it "allows to upload a file to the video field and store it" do
    Binda::Video::VideoUploader.enable_processing = true
		# Create an image field setting on which will work
		video_setting = create(:video_setting, field_group_id: @structure.field_groups.first.id)
		# Refresh the page so the image field appear on the editor
		visit @path
		expect(@component.videos.first.video.present?).not_to be_truthy
		field_id = "component_videos_attributes_#{@component.videos.where(field_setting_id: video_setting.id ).first.id}_video"
		video_name = 'test-video.mp4'
		video_path = ::Binda::Engine.root.join('spec', 'support', video_name)
		page.execute_script("document.getElementById('#{field_id}').style.zIndex = '1'")
		page.execute_script("document.getElementById('#{field_id}').style.opacity = '1'")
		page.attach_file(field_id, video_path)
		wait_for_ajax
		sleep 1 # wait for animation to complete
		@component.reload
		video = @component.videos.first
		within "#fileupload-#{video.id}" do
			expect(page).to have_content video_name
			expect(page).to have_content (video.file_size.to_f / 1.megabyte).round(2)
		end
		visit @path
		expect( File.basename( video.video.path ) ).to eq video_name
		within "#fileupload-#{video.id}" do
			expect(page).to have_content video_name
			expect(page).to have_content (video.file_size.to_f / 1.megabyte).round(2)
		end
    Binda::Video::VideoUploader.enable_processing = false
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
		# initial_repeaters_count = @component.repeaters.count
		# expect( all('.form-item--repeater-fields').count ).to eq( initial_repeaters_count )
		# click_link "form-item--repeater-#{@component.repeaters.first.field_setting.id}--add-new-button"
		# # This find method forces Capybara to wait for Ajax request
		# find "#repeater_#{@component.repeaters.pluck(:id).last}"
		# sleep 3
		# expect( all('.form-item--repeater-fields').count ).to eq( initial_repeaters_count + 1 )
		skip "not implemented yet"
	end

	it "allows to relate a component to other ones" do
		skip "not implemented yet"
	end

	it "allows to sort repeaters" do
		@structure.reload
		repeater_setting = @structure.field_groups.first.field_settings.find{|field_setting| field_setting.field_type == 'repeater' }
		# Make sure there are at least 2 repeaters
		Binda::Repeater.create([{
			fieldable_id: @component.id,
			fieldable_type: @component.class.name,
			field_setting_id: repeater_setting.id
		},{
			fieldable_id: @component.id,
			fieldable_type: @component.class.name,
			field_setting_id: repeater_setting.id			
		}])
		# Get all repeaters associated to repeater_setting and component
		repeaters_ids = Binda::Repeater.where(
			fieldable_id: @component.id,
			fieldable_type: @component.class.name,
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
			.drag_and_drop_by(target, 1, 80) # move it a bit more so we are 100% sure it's below the latest
			.perform
		wait_for_ajax
		# They should be sorted by new position
		repeaters_dom_ids = all("ul#form--list-#{repeater_setting.id} li").map{|item| item[:id]}
		expect(repeaters_dom_ids.last).to eq "form--list-item-#{repeaters_ids.first}"
		expect(repeaters_dom_ids.first).to eq "form--list-item-#{repeaters_ids[1]}"
	end

end