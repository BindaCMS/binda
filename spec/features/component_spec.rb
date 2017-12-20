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
		expect( page ).to have_current_path( path )
		expect( page.body.index( first_component.name ) ).to be < page.body.index( last_component.name ) 

		first_component.update_attribute( 'position', last_position )
		last_component.update_attribute( 'position', first_position )

		first_component.reload
		last_component.reload

		visit path
		expect( page.body.index( first_component.name ) ).to be > page.body.index( last_component.name )
	end
end

describe "GET component#edit", type: :feature, js: true do

	let(:user){ Binda::User.first }

	before(:context) do
		@structure = create(:article_structure_with_components_and_fields)
		@component = @structure.components.first
	end

	before(:example) do
		sign_in user
	end

	it "isn't blocked by any Rails error" do
		path = binda.edit_structure_component_path( structure_id: @structure.slug, id: @component.slug ) 
		visit path
		expect( page ).to have_current_path( path )
		expect( page ).to have_selector "#component_name[value='#{ @component.name }']"
	end

	# This test should be refactored as often ends throwing this error:
	# 
	## Failure/Error: raise Capybara::ExpectationNotMet.new('Timed out waiting for Selenium session reset') if (Capybara::Helpers.monotonic_time - start_time) >= 10   
	##     Capybara::ExpectationNotMet: Timed out waiting for Selenium session reset
	it "allows to edit a string field" do
		path = binda.edit_structure_component_path( @structure, @component )
		visit path

		expect( page ).to have_current_path( path )

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
		path = binda.edit_structure_component_path( @structure, @component )
		visit path
		
		expect( page ).to have_current_path( path )
		
		@component.reload

		ids = @component.repeaters.first.string_ids
	
		repeater_expand_btn = "#repeater_#{@component.repeaters.first.id} .form-item--collapse-btn span"
		find(repeater_expand_btn).click
		# wait animation
		sleep 1
		
		string_field = "component_repeaters_attributes_#{@component.repeaters.first.id}_strings_attributes_#{ids[ids.length-1]}_content"
		string_value = 'oh my lorem'
		find("##{string_field}")

		fill_in string_field, with: string_value
		click_button "save"

		visit path

		find(repeater_expand_btn).click
		# wait animation
		sleep 1

		expect(page).to have_field(string_field)
		expect(page).to have_field(string_field, with: string_value)		
	end

	it "allows to create multiple new repeater items clicking the button" do
		skip "not implemeted yet"
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
		image_setting = create(:image_setting, field_group_id: @structure.field_groups.first.id)
		
		path = binda.edit_structure_component_path( @structure, @component )
		visit path
		expect( page ).to have_current_path( path )

		expect( @component.images.first.image.present? ).not_to be_truthy

		field_id = "component_images_attributes_#{@component.images.where(field_setting_id: image_setting.id ).first.id}_image"
		image_name = 'test-image.jpg'
		image_path = ::Binda::Engine.root.join('spec', 'support', image_name)
		page.execute_script("document.getElementById('#{field_id}').style.zIndex = '1'")
		page.execute_script("document.getElementById('#{field_id}').style.opacity = '1'")
		page.attach_file( field_id, image_path )
		
		wait_for_ajax
		sleep 1 # wait for animation to complete
	
		@component.reload
		image = @component.images.first

    if CarrierWave::Uploader::Base.storage == CarrierWave::Storage::File
      file = MiniMagick::Image.open(::Rails.root.join(image.image.path))
    else
      file = MiniMagick::Image.open(image.image.url)
    end

		within "#fileupload-#{image.id}" do
			expect( page ).to have_content image_name
			expect( page ).to have_content file.width
		end

		visit path

		expect( File.basename( image.image.path ) ).to eq image_name
		within "#fileupload-#{image.id}" do
			expect( page ).to have_content image_name
			expect( page ).to have_content file.width
		end
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
		# path = binda.edit_structure_component_path( @structure, @component )
		# visit path
		# expect( page ).to have_current_path( path )
		# initial_repeaters_count = @component.repeaters.count
		# expect( all('.form-item--repeater-fields').count ).to eq( initial_repeaters_count )
		# click_link "form-item--repeater-#{@component.repeaters.first.field_setting.id}--add-new-button"
		# # This find method forces Capybara to wait for Ajax request
		# find "#repeater_#{@component.repeaters.pluck(:id).last}"
		# sleep 3
		# expect( all('.form-item--repeater-fields').count ).to eq( initial_repeaters_count + 1 )
		skip "not implemented yet"
	end

	it "allows to reorder repeater elements" do
		# This is pretty difficult, probably not reliable either
		skip "not implemented yet"
	end

	it "allows to relate a component to other ones" do
		skip "not implemented yet"
	end

	it "should not be possible to relate a component to itself" do
		skip "not implemented yet"
	end

end