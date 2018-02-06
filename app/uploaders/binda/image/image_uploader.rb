module Binda
  class Image::ImageUploader < CarrierWave::Uploader::Base

    # Include RMagick or MiniMagick support:
    # include CarrierWave::RMagick
    include CarrierWave::MiniMagick

    process :register_image_details
    process :register_details

    # Choose what kind of storage to use for this uploader:
    # storage :file
    # storage :fog

    # Override the directory where uploaded files will be stored.
    # This is a sensible default for uploaders that are meant to be mounted:
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    # https://github.com/carrierwaveuploader/carrierwave/wiki/How-to%3A-Make-Carrierwave-work-on-Heroku
    def cache_dir
      "#{Rails.root}/tmp/uploads"
    end

    # Provide a default URL as a default if there hasn't been a file uploaded:
    # def default_url
    #   # For Rails 3.1+ asset pipeline compatibility:
    #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
    #
    #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
    # end

    # Process files as they are uploaded:
    # process scale: [200, 300]
    #
    # def scale(width, height)
    #   # do something
    # end

    # Create different versions of your uploaded files:
    # version :thumb do
    #   process resize_to_fit: [50, 50]
    # end

    # ========== IMPORTANT ===========
    # If you change this remember to change the methods on app/models/binda/component.rb

    version :thumb do
      process resize_to_fit: [200, 200]
    end

    # ================================

    # Add a white list of extensions which are allowed to be uploaded.
    # For images you might use something like this:
    # def extension_whitelist
    #   %w(jpg jpeg gif png)
    # end
    def content_type_whitelist
      /image\//
    end

    # Override the filename of the uploaded files:
    # Avoid using model.id or version_name here, see uploader/store.rb for details.
    # def filename
    #   "something.jpg" if original_filename
    # end

    # @see https://github.com/carrierwaveuploader/carrierwave/wiki/How-to%3A-Get-image-dimensions
    def register_image_details
      if file && model
        model.file_width, model.file_height = ::MiniMagick::Image.open(file.file)[:dimensions]
      end
    end

    # @see https://github.com/carrierwaveuploader/carrierwave/wiki/how-to:-store-the-uploaded-file-size-and-content-type
    def register_details
      if file && model
        model.content_type = file.content_type if file.content_type
        model.file_size = file.size
      end
    end

    # Generating medium and large version creates slowness if the uploaded file is a gif.
    #   Conditional versioning could be a solution, but you might want to do it in your 
    #   application usign a initializer.
    #   
    #   @example 
    #     require 'active_support/concern'
    #     module ComponentExtension
    #       extend ActiveSupport::Concern
    #       included do 
    #         version :medium, if: :is_not_gif? do
    #           process resize_to_fit: [700, 700]
    #         end
    #         
    #         version :large, if: :is_not_gif? do
    #           process resize_to_fit: [1400, 1400]
    #         end
    #       end
    #       protected
    #         class_methods do
    #           def is_not_gif? new_file
    #             new_file.extension.downcase != 'gif'
    #           end
    #         end
    #     end
    #     ::Binda::Component.send(:include, ComponentExtension)
  end
end