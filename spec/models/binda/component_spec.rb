require 'rails_helper'

module Binda
  RSpec.describe Component, type: :model do
		
		before(:all) do
			@structure = build(:structure)
		end

		let( :new_component ) { Binda::Component.new }

		it "cannot be saved when name is blank" do
			expect { new_component.save! }.to raise_error ActiveRecord::RecordInvalid
		end

		it "cannot be saved if no structure is specified" do
			new_component.name = 'Component #1'
			expect { new_component.save! }.to raise_error ActiveRecord::RecordInvalid
		end

		it "can be saved if name and structred are provided" do
			new_component.name = 'Component #1'
			new_component.structure = @structure
			expect { new_component.save! }.not_to raise_error
		end

		it "creates slug automagically" do
			new_component.name = 'Component #1'
			new_component.structure = @structure
			new_component.save!
			expect( new_component.slug ).to eq "component-1"
		end

		it "destroys all fields related to it when it's deleted" do
			skip "not implemented yet"
		end

		it "can have multiple categories" do
			skip "not implemented yet"
		end

		# - - - - - - - - - - - - - - - - - - - -
		# COMPONENT HELPERS
		# - - - - - - - - - - - - - - - - - - - -

		it "gets text content using get_text()" do
			skip "not implemented yet"
		end

		it "throws an error calling get_text() on wrong slug" do
			skip "not implemented yet"
		end

		it "returns false when has_text() is not called on a text belonging to this component" do
			skip "not implemented yet"
		end

		it "returns true when has_text() is called on a text belonging to this component" do
			skip "not implemented yet"
		end

		it "gets text using get_image_path()" do
			skip "not implemented yet"
		end

		it "throws an error calling get_image_path() on wrong slug" do
			skip "not implemented yet"
		end

		it "gets text using get_image_url()" do
			skip "not implemented yet"
		end

		it "throws an error calling get_image_url() on wrong slug" do
			skip "not implemented yet"
		end

		it "returns false when has_image() is not called on a asset belonging to this component" do
			skip "not implemented yet"
		end

		it "gets text content using get_date()" do
			skip "not implemented yet"
		end

		it "throws an error calling get_date() on wrong slug" do
			skip "not implemented yet"
		end

		it "returns false when has_date() is not called on a date belonging to this component" do
			skip "not implemented yet"
		end

		it "gets text content using get_repeater()" do
			skip "not implemented yet"
		end

		it "throws an error calling get_repeater() on wrong slug" do
			skip "not implemented yet"
		end

		it "returns false when has_repeater() is not called on a repeater belonging to this component" do
			skip "not implemented yet"
		end
  end
end
