require "rails_helper"

module Binda
	RSpec.describe Radio, type: :model do
		
		before(:context) do
			@field_group = create(:field_group)
			@radio_setting = create(:radio_setting_with_choices, field_group_id: @field_group.id )
			@component = create(:component, structure_id: @field_group.structure.id )
			@radio = @component.radios.create({ field_setting_id: @radio_setting.id })
		end

		it "should let you choose a value" do
			# clean choice selection
			@radio.choice = nil
			@radio.choice = @radio_setting.choices.first
			expect( @radio.choice.id ).to be( @radio_setting.choices.first.id )
		end

		it "shouldn't let you choose more than a value" do
			skip "to be implemented, though this might need some refactory as association 'has_many' cannot be overriden with 'has_one', you can currently give more than one choice if you are not careful"
		end

		it "should let you see the choosen value" do
			# clean choice selection
			@radio.choice = nil
			@radio.choice = @radio_setting.choices.first
			selection = @component.get_radio_choice( @radio_setting.slug )
			expect( selection ).to eq( @radio.choice )
		end

	end
end
