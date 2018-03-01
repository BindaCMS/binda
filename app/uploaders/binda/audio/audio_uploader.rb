module Binda
  class Audio::AudioUploader < CarrierWave::Uploader::Base

    process :register_details

    # Override the directory where uploaded files will be stored.
    # This is a sensible default for uploaders that are meant to be mounted:
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    # Add a white list of extensions which are allowed to be uploaded.
    # For images you might use something like this:
    def extension_whitelist
      %w(mp3 m4a m4b ra ram wav ogg oga mid midi wma wax mka)
    end

    # @see https://github.com/carrierwaveuploader/carrierwave/wiki/how-to:-store-the-uploaded-file-size-and-content-type
    def register_details
        if file && model
            model.content_type = file.content_type if file.content_type
            model.file_size = file.size
        end
    end

  end
end