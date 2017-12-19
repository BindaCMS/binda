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

		it "can create new choice and set it as default" do
			field_setting = create(:radio_setting)
			# Reload in order to update the ActiveRecord object with the 
			# choices created during after_create callback
			field_setting.reload
			field_setting.choices.create({ label: 'First chioce', value: 'Lorem ipsum' })
			expect( field_setting.choices.any? ).to be_truthy
		end

		it "get a default choice if none is specified" do 
			field_setting = create(:radio_setting)
			# Reload in order to update the ActiveRecord object with the 
			# choices created during after_create callback
			field_setting.reload
			radio = Radio.create(field_setting_id: field_setting.id)
			radio.reload
			# field_setting.field_group.structure.components.create()
			expect( radio.choices.any? ).to be_truthy
		end

		it "select another choice as default if the original default choice has been deleted" do
			field_setting = create(:radio_setting)
			# Reload in order to update the ActiveRecord object with the 
			# choices created during after_create callback
			field_setting.reload
			new_choice = field_setting.choices.create({ label: 'First chioce', value: 'Lorem ipsum' })
			Choice.find(field_setting.default_choice_id).destroy
			# Reload again to get the results of the after_destroy callback
			field_setting.reload
			expect( field_setting.default_choice_id ).to eq(new_choice.id)
		end

	end
end