require "rails_helper"

module Binda
	RSpec.describe FieldSetting, type: :model do


		# this shouldn't be here. Need fixing
		# before(:context) do
		# 	@component = create( :component )
		# 	@radio = create( :radio, fieldable: @component )
		# end

		# this shouldn't be here. Need fixing
		# it "should let you create a radio item with choices" do
		# 	choices = @radio.get_choices
		# 	expect( choices.length ).to eq(3)
		# 	expect( @radio.content ).to eq('f1')
		# 	@radio.update_attribute( 'content', 'f3' )
		# 	expect( @radio.content ).to eq('f3')
		# 	expect( @radio.get_choice ).to eq('f3')
		# end

		before(:context) do 
			@field_setting = create(:radio_setting)
		end

		it "can create new choice and set it as default" do
			@field_setting.choices.create({ label: 'First chioce', value: 'Lorem ipsum' })
			expect( @field_setting.choices.any? ).to be_truthy
		end

	end
end