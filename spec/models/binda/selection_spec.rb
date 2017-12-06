require 'rails_helper'

module Binda
  RSpec.describe Selection, type: :model do
    
		before(:context) do
			@field_group = create(:field_group)
			@selection_setting = create(:selection_setting_with_choices, field_group_id: @field_group.id )
			@component = create(:component, structure_id: @field_group.structure.id )
			@component.reload # this is needed in order to get nwe values create during the after_save callback
		end

		it "should let you choose some values" do
			selection = @component.selections.first
			selection.choices.clear
			selection.choices << @selection_setting.choices.first
			selection.choices << @selection_setting.choices.last
			expect( selection.choices.length ).to eq(2)
		end

		it "should let you see the choosen values" do
			selection = @component.selections.first
			selection.choices.clear
			selection.choices << @selection_setting.choices.first
			selected_choice = @component.get_selection_choice( @selection_setting.slug )
			expect( selected_choice ).to eq( { label: selection.choices.take.label, value: selection.choices.take.value } )
		end
  end
end
