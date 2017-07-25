require "rails_helper"

module Binda
	RSpec.describe Select, type: :model do
		
		before(:context) do
			@field_group = create(:field_group)
			@select_setting = create(:select_setting_with_choices, field_group_id: @field_group.id )
			@component = create(:component, structure_id: @field_group.structure.id )
			@select = @component.selects.create({ field_setting_id: @select_setting.id })
		end

		it "should let you choose some values" do
			@select.choices << @select_setting.choices.first
			@select.choices << @select_setting.choices.last
			expect( @select.choices.length ).to eq(2)
		end

		it "should let you see the choosen values" do
			# clean selection
			@select.choices = []
			@select.choices << @select_setting.choices.first
			selection = @component.get_select_choices( @select_setting.slug )
			expect( selection ).to eq( @select.choices )
		end

	end
end
