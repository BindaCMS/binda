require "rails_helper"

module Binda
	RSpec.describe Radio, type: :model do
		
		before(:context) do
			@field_group = create(:field_group)
			@radio_setting = create(:radio_setting_with_choices, field_group_id: @field_group.id )
			@component = create(:component, structure_id: @field_group.structure.id )
			@component.reload # reload otherwise @component doesn't know about radio (is it possible? this is due to after_save callback)
		end

		it "should let you choose a value" do
			# clean choice selection
			radio = @component.radios.first
			radio.choices.clear
			radio.choices << @radio_setting.choices.first
			expect( radio.choices.first.id ).to be( @radio_setting.choices.first.id )
		end

		it "shouldn't let you choose more than a value" do
			skip "to be implemented, though this might need some refactory as association 'has_many' cannot be overriden with 'has_one', you can currently give more than one choice if you are not careful"
		end

		it "should let you see the choosen value" do
			# clean choice selection
			radio = @component.radios.first
			radio.choices << @radio_setting.choices.first
			radio.save!
			radio_selection = @component.get_radio_choice( @radio_setting.slug )
			expect( radio_selection ).to eq( { label: radio.choices.first.label, value: radio.choices.first.value } )
		end
		
		it "cannot have more than one choice" do
			# radio = @component.radios.first
			# expect{radio.choice << @radio_setting.choices.first}.to raise_error ActiveModel::ValidationError
			skip('not implemented yet')
		end

		it "shouldn't let you select choice if read only" do
			radio = @component.radios.first
			radio.choices.clear
			@radio_setting.read_only = true
      @radio_setting.save!
			expect(@radio_setting.reload.read_only).to be(true)
			radio.choices << @radio_setting.choices.first
			expect{ radio.save! }.to raise_error ActiveRecord::RecordInvalid
		end

	end
end
