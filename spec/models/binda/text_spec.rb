require 'rails_helper'

module Binda
	RSpec.describe Text, type: :model do

		before(:context) do
			@structure = create(:article_structure_with_components_and_fields)
			# @structure = build_stubbed(:article_structure_with_components_and_fields)
			@component = @structure.components.first
			@repeater = @component.repeaters.first
			@settings = @structure.field_groups.first.field_settings

			@component_text_setting = @settings.find{ |fs| fs.field_type == 'text' }
			@component_text = @component.texts.find{ |t| t.field_setting_id = @component_text_setting.id }
			@repeater_text_setting = @settings.find{ |fs| fs.field_type == 'repeater' }.children.find{ |c| c.field_type == 'text' }
			@repeater_text = @repeater.texts.find{ |t| t.field_setting_id == @repeater_text_setting.id }
		end

		it 'belongs to a component' do
			expect( @component_text.fieldable ).to eq( @component )
		end

		it 'belongs to a repeater' do
			expect( @repeater_text.fieldable ).not_to eq( @component )
			expect( @repeater_text.fieldable ).to eq( @repeater )
		end

		it 'returns blank on get_text() if there is no content' do 
			slug = @component_text.field_setting.slug
			expect( @component.get_text( slug ) ).to eq( @component_text.content )
			@component_text.update_attribute( 'content', '' )
			expect( @component.get_text( slug ) ).to eq('')
		end
		
		it "returns nil on get_text() if the text field has been recently created but the component doesn't have any text belonging to that text field" do
			@text_field_setting = @structure.field_groups.first.field_settings.create(name: 'Testing sting', field_type: 'text')
			
			# expect error, use block with {} parethesis 
			# see https://stackoverflow.com/questions/19960831/rspec-expect-vs-expect-with-block-whats-the-difference
			expect{ @component.get_text( @text_field_setting.slug ) }.to raise_error ArgumentError

			@component.texts.create({ content: 'Lorem', field_setting_id: @text_field_setting.id })
			expect( @component.get_text( @text_field_setting.slug ) ).to eq('Lorem')
		end

	end
end