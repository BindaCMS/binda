require 'rails_helper'

# @see https://github.com/carrierwaveuploader/carrierwave#testing-with-carrierwave
module Binda
  RSpec.describe Image, type: :model do
  include CarrierWave::Test::Matchers

    before(:context) do
      Image::ImageUploader.enable_processing = true
    end

  	before(:example) do
  		@component = create(:component)
  		@image_setting = create(:image_setting, field_group_id: @component.structure.field_groups.first.id)
  	end

    after(:context) do
      Image::ImageUploader.enable_processing = false
    end

  	it "stores height and width" do
      image_name = 'test-image.jpg'
      image_path = ::Binda::Engine.root.join('spec', 'support', image_name)
      image_record = @component.reload.images.first
      image_record.image = image_path.open
  		expect(image_record.save!).to be_truthy
  		expect(image_record.file_width).to be_within(1).of(400) # image is 400px wide
  		expect(image_record.file_height).to be_within(1).of(226) # image is 226px high
  	end

  	it "stores content_type and file size" do
      image_name = 'test-image.jpg'
      image_path = ::Binda::Engine.root.join('spec', 'support', image_name)
      image_record = @component.reload.images.first
      image_record.image = image_path.open
  		expect(image_record.save!).to be_truthy
  		expect(image_record.content_type).to eq 'image/jpeg'
  		expect(image_record.file_size).to be_within(1000).of(14000) # image is 14kb
  	end

    it "registers details if you call register_deatils method (also in rake task)"  do
      skip("don't know how to test it")
    end
  end
end
