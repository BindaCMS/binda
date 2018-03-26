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
	  expect(svg_record.content_type).to eq 'image/svg+xml'
	  expect(svg_record.file_size).to be_within(400).of(600) # audio is 300kb
	end
  end
end
