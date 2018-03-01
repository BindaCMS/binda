require 'rails_helper'

# @see https://github.com/carrierwaveuploader/carrierwave#testing-with-carrierwave
module Binda
  RSpec.describe Audio, type: :model do
  include CarrierWave::Test::Matchers

    before(:context) do
      Binda::Audio::AudioUploader.enable_processing = true
    end

    before(:example) do
      @component = create(:component)
      @audio_setting = create(:audio_setting, field_group_id: @component.structure.field_groups.first.id)
    end

    after(:context) do
      Binda::Audio::AudioUploader.enable_processing = false
    end

    it "stores content_type and file size" do
      audio_name = 'test-audio.mp3'
      audio_path = ::Binda::Engine.root.join('spec', 'support', audio_name)
      audio_record = @component.reload.audios.first
      audio_record.audio = audio_path.open
      expect(audio_record.save!).to be_truthy
      expect(audio_record.content_type).to eq 'audio/mpeg'
      expect(audio_record.file_size).to be_within(100000).of(400000) # audio is 300kb
    end
  end
end
