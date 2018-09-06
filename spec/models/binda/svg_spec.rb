require 'rails_helper'

module Binda
  RSpec.describe Svg, type: :model do

		include CarrierWave::Test::Matchers

		before(:context) do
			SvgUploader.enable_processing = true
		end

		before(:example) do
			@component = create(:component)
			@svg_setting = create(:svg_setting, field_group_id: @component.structure.field_groups.first.id)
		end

		after(:context) do
			SvgUploader.enable_processing = false
		end

		it "stores content_type and file size" do
			svg_name = 'test-svg.svg'
			svg_path = ::Binda::Engine.root.join('spec', 'support', svg_name)
			svg_record = @component.reload.svgs.first
			svg_record.svg = svg_path.open
			expect(svg_record.save!).to be_truthy
			expect(svg_record.content_type).to eq 'svg/svg+xml'
			expect(svg_record.file_size).to be_within(400).of(600) # audio is 300kb
		end

		describe "when is read only" do
			it "blocks any upload" do
				svg_name = 'test-svg.svg'
				svg_path = ::Binda::Engine.root.join('spec', 'support', svg_name)
				svg_record = @component.reload.svgs.first
				svg_record.svg = svg_path.open
        @svg_setting.read_only = true
        @svg_setting.save!
        expect(@svg_setting.reload.read_only).to be(true)
        expect{ svg_record.save! }.to raise_error ActiveRecord::RecordInvalid
			end
			describe "when there is already a svg" do
				it "avoid svg to be deleted" do
					svg_name = 'test-svg.svg'
					svg_path = ::Binda::Engine.root.join('spec', 'support', svg_name)
					svg_record = @component.reload.svgs.first
					svg_record.svg = svg_path.open
					expect(svg_record.save!).to be_truthy
					@svg_setting.read_only = true
          @svg_setting.save!
          expect(@svg_setting.reload.read_only).to be(true)
          svg_name = 'test-svg.svg'
          svg_path = ::Binda::Engine.root.join('spec', 'support', svg_name)
          svg_record = @component.reload.svgs.first
          svg_record.svg = svg_path.open
          svg_record.remove_svg
          expect{ svg_record.save! }.to raise_error ActiveRecord::RecordInvalid
				end
				it "blocks any update" do
					svg_name = 'test-svg.svg'
					svg_path = ::Binda::Engine.root.join('spec', 'support', svg_name)
					svg_record = @component.reload.svgs.first
					svg_record.svg = svg_path.open
					expect(svg_record.save!).to be_truthy
					@svg_setting.read_only = true
          @svg_setting.save!
          expect(@svg_setting.reload.read_only).to be(true)
					svg_name = 'test-svg.svg'
					svg_path = ::Binda::Engine.root.join('spec', 'support', svg_name)
					svg_record = @component.reload.svgs.first
					svg_record.svg = svg_path.open
          expect{ svg_record.save! }.to raise_error ActiveRecord::RecordInvalid
				end
			end
		end

	end
end
