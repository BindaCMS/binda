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

	end
end