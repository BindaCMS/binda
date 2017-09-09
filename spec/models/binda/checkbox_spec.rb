require "rails_helper"

module Binda
	RSpec.describe Checkbox, type: :model do
		
		before(:context) do
			@field_group = create(:field_group)
			@checkboxes_setting = create(:selection_setting_with_choices, field_group_id: @field_group.id )
			@component = create(:component, structure_id: @field_group.structure.id )
			@checkboxes = @component.checkboxes.create!({ field_setting_id: @checkboxes_setting.id })
		end

		it "should let you choose some values" do
			@checkboxes.choices.clear
			@checkboxes.choices << @checkboxes_setting.choices.first
			@checkboxes.choices << @checkboxes_setting.choices.last
			expect( @checkboxes.choices.length ).to eq(2)
		end

		it "should let you see the choosen values" do
			@checkboxes.choices.clear
			@checkboxes.choices << @checkboxes_setting.choices.first
			@checkboxes.choices << @checkboxes_setting.choices.last
			checkboxes = @component.get_checkbox_choices( @checkboxes_setting.slug )
			expect( checkboxes ).to eq( [
				{ label: @checkboxes.choices.first.label, value: @checkboxes.choices.first.value },
				{ label: @checkboxes.choices.last.label, value: @checkboxes.choices.last.value }
				] )
		end

	end
end