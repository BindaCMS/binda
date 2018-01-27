require 'rails_helper'

module Binda
  RSpec.describe Selection, type: :model do

		before(:example) do
			@field_group = create(:field_group)
			@setting = create(:selection_setting_with_choices, field_group_id: @field_group.id )
			# Reload in order to update the Active Record with what has been created by the callbacks
			@setting.reload
			@component = create(:component, structure_id: @field_group.structure.id )
			@component.reload # this is needed in order to get nwe values create during the after_save callback
			@selection = @component.selections.first
		end

		it "stores selected choices" do
			@selection.choices.clear
			@selection.choices << @setting.choices.first
			@selection.choices << @setting.choices.last
			expect(@selection.choices.length).to eq(2)
		end

		it "retrieves selected choices" do
			@selection.choices.clear
			@selection.choices << @setting.choices.first
			@selected_choice = @component.get_selection_choice(@setting.slug)
			expect(@selected_choice).to eq( { label: @selection.choices.take.label, value: @selection.choices.take.value } )
		end

		it "doesn't have any choice selected by default" do
			expect(@selection.choices.any?).to be false
		end

		it "is updated if one of its choices is deleted via field setting" do
			# Add a choice to the selection field choosing from the ones available
			@selection.choices << @setting.choices.first
			@selection.save
			@selection.reload
			expect(@selection.choices.any?).to be true
			# Delete the choice from the setting (not the selection)
			@setting.choices.first.destroy
			# You should expect the change reflected on the selection field as well
			@selection.reload
			expect(@selection.choices.any?).to be false
		end

		it "throws a warning when is required to have a choice but none is available" do
			# @see https://stackoverflow.com/a/34291946/1498118
			# expect{@setting.update(allow_null: false)}.to output.to_stderr
			skip "not implemented yet"
		end

		it "fixes all selection that have no choice using the default choice if present" do
			@setting.update(allow_null: false)

			# make sure the selection doesn't have any choice yet
			expect(@selection.choices.empty?).to be true

			# At this point we have an situation:
			# selection it's now required to have a choice, but it has none.
			# Let's fix it!
			Binda::Selection.add_default_choice_to_all_selections_with_no_choices
			
			@selection.reload
			expect(@selection.choices.empty?).to be false
			expect(@selection.choices.first.id).to eq @setting.default_choice_id
		end

		it "throws an error if you try to fix all selection that have no choice but there no default choice as well" do
			skip "not implemented yet"
		end

  end
end