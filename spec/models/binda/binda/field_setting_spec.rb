require "rails_helper"

module Binda
	RSpec.describe FieldSetting, type: :model do

		before(:context) do
			@component = create( :component )
			@radio = create( :radio, fieldable: @component )
		end

		it "should let you create a radio item with choices" do
			choices = @radio.get_choices
			expect( choices.length ).to eq(3)
			expect( @radio.content ).to eq('fruit_1')
			@radio.update_attribute( 'content', 'fruit_3' )
			expect( @radio.content ).to eq('fruit_3')
			expect( @radio.get_choice ).to eq('cucumber')
		end

	end
end