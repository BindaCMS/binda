require 'rails_helper'

module Binda
  RSpec.describe Choice, type: :model do
    it "must be associated to a field setting" do
    	choice = Choice.new(label: 'first', value: 'first')
      expect{choice.save!}.to raise_error ActiveRecord::RecordInvalid
      setting = create(:selection_setting)
      choice.field_setting_id = setting.id
      expect(choice.save!).to be true
    end

    it "can be attached to a select field" do
      component = create(:component_and_selection)
      component.reload
      selection = component.selections.first
      expect(selection.choices.any?).to be false
      choice = create(:choice, field_setting_id: selection.field_setting.id)
      selection.choices << choice
      expect(selection.reload.choices.any?).to be true
    end

    it "can be attached to a radio field" do
      component = create(:component_and_radio)
      component.reload
      radio = component.radios.first
      expect(radio.choices.any?).to be false
      choice = create(:choice, field_setting_id: radio.field_setting.id)
      radio.choices << choice
      expect(radio.reload.choices.any?).to be true
    end

    it "can be attached to a checkbox field" do
      component = create(:component_and_checkbox)
      component.reload
      checkbox = component.checkboxes.first
      expect(checkbox.choices.any?).to be false
      choice = create(:choice, field_setting_id: checkbox.field_setting.id)
      checkbox.choices << choice
      expect(checkbox.reload.choices.any?).to be true
    end

    it "cannot be deleted if field setting requires at least a choice and this is the last one" do
      component = create(:component_and_selection)
      component.reload
      selection = component.selections.first
      selection.field_setting.update_attribute(:allow_null, false)
      # Automagically creates a choice to avoid issues, remeber you set allow_null=false
      expect(selection.field_setting.reload.choices.any?).to be true
      expect(selection.choices.first.destroy).to be false
    end

  end
end
