require 'rails_helper'

module Binda
  RSpec.describe Selection, type: :model do
    
		before(:context) do
			@field_group = create(:field_group)
			@selection_setting = create(:selection_setting_with_choices, field_group_id: @field_group.id )
			@component = create(:component, structure_id: @field_group.structure.id )
			@selection = @component.selections.create({ field_setting_id: @selection_setting.id })
		end

		it "should let you choose some values" do
			@selection.choices.clear
			@selection.choices << @selection_setting.choices.first
			@selection.choices << @selection_setting.choices.last
			expect( @selection.choices.length ).to eq(2)
		end

		it "should let you see the choosen values" do
			@selection.choices.clear
			@selection.choices << @selection_setting.choices.first
			selection = @component.get_selection_choice( @selection_setting.slug )
			expect( selection ).to eq( { label: @selection.choices.take.label, value: @selection.choices.take.value } )
		end
  end
end
