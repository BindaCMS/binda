require 'rails_helper'

# @see https://github.com/carrierwaveuploader/carrierwave#testing-with-carrierwave
module Binda
  RSpec.describe Audio, type: :model do
  include CarrierWave::Test::Matchers

    before(:context) do
      Audio::AudioUploader.enable_processing = true
    end

    before(:example) do
      @component = create(:component)
      @audio_setting = create(:audio_setting, field_group_id: @component.structure.field_groups.first.id)
    end

    after(:context) do
      Audio::AudioUploader.enable_processing = false
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

    describe "when is read only" do
      it "blocks any upload" do
        @audio_setting.read_only = true
        @audio_setting.save!
        expect(@audio_setting.reload.read_only).to be(true)
        audio_name = 'test-audio.mp3'
        audio_path = ::Binda::Engine.root.join('spec', 'support', audio_name)
        audio_record = @component.reload.audios.first
        audio_record.audio = audio_path.open
        expect{ audio_record.save! }.to raise_error ActiveRecord::RecordInvalid
      end
      describe "when there is already a image" do
        it "avoid audio to be deleted" do
          audio_name = 'test-audio.mp3'
          audio_path = ::Binda::Engine.root.join('spec', 'support', audio_name)
          audio_record = @component.reload.audios.first
          audio_record.audio = audio_path.open
          expect(audio_record.save!).to be_truthy
          @audio_setting.read_only = true
          @audio_setting.save!
          expect(@audio_setting.reload.read_only).to be(true)
          audio_name = 'test-audio.mp3'
          audio_path = ::Binda::Engine.root.join('spec', 'support', audio_name)
          audio_record = @component.reload.audios.first
          audio_record.audio = audio_path.open
          audio_record.remove_audio
          expect{ audio_record.save! }.to raise_error ActiveRecord::RecordInvalid
        end
        it "blocks any update" do
          audio_name = 'test-audio.mp3'
          audio_path = ::Binda::Engine.root.join('spec', 'support', audio_name)
          audio_record = @component.reload.audios.first
          audio_record.audio = audio_path.open
          expect(audio_record.save!).to be_truthy
          @audio_setting.read_only = true
          @audio_setting.save!
          expect(@audio_setting.reload.read_only).to be(true)
          audio_name = 'test-audio.mp3'
          audio_path = ::Binda::Engine.root.join('spec', 'support', audio_name)
          audio_record = @component.reload.audios.first
          audio_record.audio = audio_path.open
          expect{ audio_record.save! }.to raise_error ActiveRecord::RecordInvalid
        end
      end
    end
  end
end
