module Binda
	# This class provides support for uploading images.
  class Image < Asset

    mount_uploader :image, ImageUploader

    # Register image details
    # 
    # Do not delete. This method is used by a rake task
    def register_details
      if !self.image.present?
        warn "Ops, there is no image for Binda::Image id=#{self.id}"
      elsif CarrierWave::Uploader::Base.storage == CarrierWave::Storage::File
        file = MiniMagick::Image.open(::Rails.root.join(self.image.path))
        register_details_of(file)
      else
        file = MiniMagick::Image.open(self.image.url)
        register_details_of(file)
      end
    end

    # Register image details
    # 
    # This method is used by register_details in a rake task
    def register_details_of(file)
      self.file_width = file.width
      self.file_height = file.height
      self.content_type = file.mime_type if file.mime_type
      self.file_size = file.size
      self.save!
      puts "Updated image details for Binda::Image id=#{self.id}"
    end

  end
end
