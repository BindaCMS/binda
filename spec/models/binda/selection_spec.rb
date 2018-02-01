require 'rails_helper'

module Binda
  RSpec.describe Selection, type: :model do

		before(:example) do
			@field_group = create(:field_group)
			@setting = create(:selection_setting, field_group_id: @field_group.id )
			@component = create(:component, structure_id: @field_group.structure.id )
			@component.reload # this is needed in order to get new values create during the after_save callback
			@selection = @component.selections.first
		end

		it "stores selected choices" do
			# @setting.choices.create!(label: 'first', value: 'first')
			@selection.choices << @setting.choices.create!(label: 'first', value: 'first')
			@selection.choices << @setting.choices.create!(label: 'second', value: 'second')
			expect(@selection.choices.length).to eq 2
		end

		it "retrieves selected choices" do
			@selection.choices << @setting.choices.create!(label: 'first', value: 'first')
			@selected_choice = @component.get_selection_choice(@setting.slug)
			expect(@selected_choice).to eq( { label: 'first', value: 'first' } )
		end

		it "doesn't have any choice selected by default" do
			expect(@selection.choices.any?).to be false
		end

		it "is updated if one of its choices is deleted via field setting" do
			# Add a choice to the selection field choosing from the ones available
			@selection.choices << @setting.choices.create!(label: 'first', value: 'first')
			expect(@selection.choices.any?).to be true
			# Delete the choice from the setting (not the selection)
			@setting.choices.first.destroy
			# You should expect the change reflected on the selection field as well
			@selection.reload
			expect(@selection.choices.any?).to be false
		end

		it "fixes all selection that have no choice using the default choice if present" do
			# generate an error using update_attributes instead of update (which means avoiding callback)
			choice = create(:choice, field_setting_id: @setting.id)
			@setting.update_column(:allow_null, false)
			@setting.update_column(:default_choice_id, choice.id)

			# make sure the selection doesn't have any choice yet
			expect(@selection.choices.empty?).to be true

			# At this point we have an situation:
			# selection it's now required to have a choice, but it has none.
			# Let's fix it!
			expect{Binda::Selection.add_default_choice_to_all_selections_with_no_choices}.not_to raise_error

			@selection.reload
			expect(@selection.choices.empty?).to be false
			expect(@selection.choices.first.id).to eq @setting.default_choice_id
		end

		it "raise an error if you try to fix all selection that have no choice but finding there are no choice whatsoever" do
			# generate an error using update_attributes instead of update (which means avoiding callback)
			@setting.update_column(:allow_null, false)

			# make sure the selection doesn't have any choice yet
			expect(@selection.choices.empty?).to be true

			# At this point we have an situation:
			# selection it's now required to have a choice, but it has none.
			# Let's fix it!
			expect{Binda::Selection.add_default_choice_to_all_selections_with_no_choices}.to raise_error RuntimeError
			# but the above cannot work as there are no choices at all!
		end

  end
end