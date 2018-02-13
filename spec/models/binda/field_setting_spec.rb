require "rails_helper"

module Binda
	RSpec.describe FieldSetting, type: :model do


		# TODO ti should be done for each field type
		describe "for each field class" do

			before(:context) do
				@board_structure = create(:board_structure)
				@board = @board_structure.reload.board
				@component_structure = create(:structure)
				@component = create(:component, structure_id: @component_structure.id)
			end
			
			FieldSetting.get_field_classes.each do |field_class|
				it "generates a field #{field_class.downcase.underscore} for each component to which is associated" do
					field_setting = create(
						:field_setting,
						field_type: field_class.underscore,
						field_group_id: @component_structure.field_groups.first.id
						)
					expect{
						"Binda::#{field_class}".constantize.where(
							field_setting_id: field_setting.id,
							fieldable_id: @component.id,
							fieldable_type: @component.class.name
						).first
					}.not_to raise_error
				end
				it "generates a field #{field_class.downcase.underscore} for each component to which is associated" do
					field_setting = create(
						:field_setting,
						field_type: field_class.underscore,
						field_group_id: @board_structure.field_groups.first.id
						)
					expect{
						"Binda::#{field_class}".constantize.where(
							field_setting_id: field_setting.id,
							fieldable_id: @board.id,
							fieldable_type: @board.class.name
						).first
					}.not_to raise_error
				end
			end

			describe 'which are children of a repeater' do

				before(:context) do
					@repeater_setting = create(:repeater_setting, field_group_id: @component_structure.field_groups.first.id)
					@repeater = @component.repeaters.create(field_setting_id: @repeater_setting.id)
				end

				FieldSetting.get_field_classes.each do |field_class|
					# TODO ti should be done for each field type
					it "generates a field #{field_class.downcase.underscore} for each repeater to which is associated" do
						field_setting = create(
							:field_setting,
							field_type: field_class.underscore,
							field_group_id: @component_structure.field_groups.first.id,
							ancestry: @repeater_setting.id.to_s
						)
						expect{
							"Binda::#{field_class}".constantize.where(
								field_setting_id: field_setting.id,
								fieldable_id: @repeater.id,
								fieldable_type: @repeater.class.name
							).first
						}.not_to raise_error
					end
				end
			end
		end

		describe "with type selection/radio/checkbox" do

			before(:example) do
				# Create settings for the selection field
				@selection_setting = create(:selection_setting)
				# Create settings for the radio field which requires at least a choice
				@radio_setting = create(:radio_setting)
			end

			it "doesn't have any choice by default if allow_null=true" do
				expect(@selection_setting.choices.any?).to be false
			end

			it "has a default choice by default if allow_null=true" do
				expect(@selection_setting.default_choice_id).to be_nil
			end

			it "has choice by default if allow_null=false" do
				expect(@radio_setting.choices.any?).to be true
			end

			it "doesn't have a default choice by default if allow_null=false" do
				expect(@radio_setting.default_choice_id).to be_nil
			end

			it "doesn't automatically sets the first created choice as the default one if it doesn't require at least a choice" do
				new_choice = @selection_setting.choices.create({ label: 'First chioce', value: 'Lorem ipsum' })

				# Reload in order to update the ActiveRecord object with the 
				# choices created during after_create callback
				@selection_setting.reload
				expect(@selection_setting.default_choice_id).to be nil
			end

			it "automatically creates a choice as the default one it requires at least a choice" do
				expect(@radio_setting.reload.default_choice.present?).to be true
			end

			# it "selects another choice as default if the original default choice has been deleted" do
			# 	pending "not implemented yet"
			# end

			it "forces you to replace the default choice with another one before deleting it if having at least a choice is required" do
				# Destroying the choice shouldn't be possible as there is no other choice available
				expect{@radio_setting.choices.each{|c| c.destroy!}}.to raise_error ActiveRecord::RecordNotDestroyed

				expect(@radio_setting.reload.choices.length).to eq 1
				# Make a choice to use as a fallback
				second_new_choice = @radio_setting.choices.create({ label: 'Second chioce', value: 'Lorem ipsum' })
				@radio_setting.update!(default_choice_id: second_new_choice.id)

				# Reload again to get the results of the after_destroy callback
				@radio_setting.reload
				expect(@radio_setting.choices.length).to eq 2
				expect(second_new_choice.destroy).to be_truthy
			end


			it "before deleting choice X, it forces you to replace choice X with choice Y on all selections that have just choice X and where the current field setting requires at least one choice" do
				# Expect to be unable to delete it as it's the only available and the radio field is required to have one
				expect(@radio_setting.choices.first.destroy).to be false

				# Create a new choice for the field setting
				new_choice = @radio_setting.choices.create({ label: 'First chioce', value: 'Lorem ipsum' })

				# Create a component
				component = @radio_setting.structure.components.create(name:'my component')

				# Expect component to have a radio with the default choice (not the new_choice)
				expect(component.reload.get_radio_choice(@radio_setting.slug)).not_to eq({ label: new_choice.label, value: new_choice.value })

				# Expect to be able to delete the first one now that it's not the only one
				expect(@radio_setting.choices.first.destroy).to be_truthy

				# Expect to see the change reflected on the radio
				expect(component.reload.get_radio_choice(@radio_setting.slug)).to eq({ label: new_choice.label, value: new_choice.value })
			end

			it "forces you to add another choice before clearing all choices. Only when it requires to have at least choice" do
				# Create a component
				component = @radio_setting.structure.components.create(name:'my component')

				# Get directly that radio
				radio = Binda::Radio.where(
					field_setting_id: @radio_setting.id,
					fieldable_id: component.id,
					fieldable_type: component.class.name
				).first

				# Make sure radio has one choice (the temporary default one)
				expect(radio.choices.length).to eq 1

				# Try to leave the radio without any choice selected...
				# IMPORTANT we are testing `clear` method!
				radio.choices.clear
				
				# ... and expect to not be able to do it as there's just one
				expect(radio.save).to be false

				# Create and assign another choice...
				new_choice = @radio_setting.choices.create({ label: 'First chioce', value: 'Lorem ipsum' })
				radio.choices << new_choice

				# Make sure the remaining choice is the other one
				expect(radio.choice_ids.include?(new_choice.id)).to be true

				# Now it should be possible to save
				expect(radio.save).to be_truthy
			end

			it "generates a field for each board to which is associated" do
				# Create a board
				@radio_setting.choices.create!(label: 'first', value: 'first')
				@radio_setting.structure.update!(instance_type: 'board')
				board = @radio_setting.reload.structure.board

				expect(board.persisted?).to be true

				# Get directly that radio
				expect{
					Binda::Radio.where(
						field_setting_id: @radio_setting.id,
						fieldable_id: board.id,
						fieldable_type: board.class.name
					).first
				}.not_to raise_error
				expect(board.radios.first.field_setting_id).to eq @radio_setting.id
			end

			it "automagically sets allow_null=false upon creation of a raido setting" do
				radio = build(:radio_setting, allow_null: true)
				# You can try to create a radio setting with allow_null=true and it won't fail, but...
				expect{radio.save!}.not_to raise_error
				# ... under the hood allow_null be set as false
				expect(radio.reload.allow_null).to be false
			end

			it "cannot have allow_null set to true if 'field_type' is 'radio'" do
				# Set a choice so there's no problem on saving/updating the radio setting
				@radio_setting.choices.create!(label: 'first', value: 'first')
				# You can try to set allow_null=true, but...
				expect{@radio_setting.update!(allow_null: true)}.not_to raise_error
				# ... under the hood allow_null be set as false
				expect(@radio_setting.reload.allow_null).to be false
			end

			it "is smart enough to allow to update a field setting with allow_null=false if there is no choice available" do
				expect(@selection_setting.choices.empty?).to be true
				expect{@selection_setting.update!(allow_null: false)}.not_to raise_error
				expect(@selection_setting.reload.default_choice.present?).to be true
			end

			it "assigns a default choice when field setting is updated with allow_null=false" do
				@selection_setting.choices.create(label: 'first', value: 'lorem')
				@selection_setting.update!(allow_null: false)

				expect(@selection_setting.default_choice.present?).to be true
			end
		end

		# test method Binda::FieldSetting.remove_orphan_fields
		describe "dealing with orphans" do
			it "makes sure changing field setting type will remove any orphan with the previous type" do
				pending "not implemented yet"
			end
			it "removes any field which has an association with a non existing field setting" do
				pending "not implemented yet"
			end
		end
	end
end