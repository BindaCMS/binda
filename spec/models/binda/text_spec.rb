require 'rails_helper'

module Binda
	RSpec.describe Text, type: :model do

		before(:context) do
			@structure = create(:article_structure_with_components_and_fields)
			# Update variable after callbacks
			@structure.reload
			@component = @structure.components.first
			@repeater = @component.repeaters.first
			@settings = @structure.field_groups.first.field_settings

			@component_text_setting = @settings.find{ |fs| fs.field_type == 'text' }
			@component_text = @component.texts.find{ |t| t.field_setting_id == @component_text_setting.id }
			@repeater_text_setting = @settings.find{ |fs| fs.field_type == 'repeater' }.children.find{ |c| c.field_type == 'text' }
			@repeater_text = @repeater.texts.find{ |t| t.field_setting_id == @repeater_text_setting.id }
		end

		it 'belongs to a component' do
			expect(@component_text.fieldable).to eq(@component)
		end

		it 'belongs to a repeater' do
			expect(@repeater_text.fieldable).not_to eq(@component)
			expect(@repeater_text.fieldable).to eq(@repeater)
		end

		it 'returns blank on get_text() if there is no content' do 
			slug = @component_text.field_setting.slug
			expect(@component.get_text(slug)).to eq(@component_text.content.to_s)
			expect(@component.get_text(slug)).to eq("")
		end
		
		it "returns a empty string on get_text() immediately after text setting has been created" do
			@text_field_setting = @structure.field_groups.first.field_settings.create(name: 'Testing sting', field_type: 'text')
			
			# expect error, use block with {} parethesis 
			# see https://stackoverflow.com/questions/19960831/rspec-expect-vs-expect-with-block-whats-the-difference
			expect{ @component.get_text(@text_field_setting.slug) }.not_to raise_error
		end

		it "is not possible to create 2 texts instances for the same component and the same text setting" do
			@text_field_setting = @structure.field_groups.first.field_settings.create(name: 'Testing sting 2', field_type: 'text')
			new_text = @component.texts.build({ field_setting_id: @text_field_setting.id })
			expect{ new_text.save! }.to raise_error ActiveRecord::RecordInvalid
		end

    describe "when is read only" do
      it "avoid text to be deleted" do
        @component = create(:component)
  			@text_field_setting = @structure.field_groups.first.field_settings.create(name: 'Testing string 2', field_type: 'text')
  			new_text = @component.texts.build({ field_setting_id: @text_field_setting.id })
        expect(new_text.save!).to be_truthy
        @text_field_setting.read_only = true
        @text_field_setting.save!
        new_text = @component.reload.texts.first
        expect{ new_text.save! }.to raise_error ActiveRecord::RecordInvalid
      end
      
      it "blocks any update" do
        @component = create(:component)
        @text_field_setting = @structure.field_groups.first.field_settings.create(name: 'Testing string 2', field_type: 'text')
        new_text = @component.texts.build({ field_setting_id: @text_field_setting.id })
        expect(new_text.save!).to be_truthy
        @text_field_setting.read_only = true
        @text_field_setting.save!
        new_text = @component.reload.texts.first
        new_text.update_attributes(content: "updating")
        expect{ new_text.save! }.to raise_error ActiveRecord::RecordInvalid
      end
    end
	end
end