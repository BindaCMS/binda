module Binda
	# This class provides support for uploading images.
  class Image < Asset

    mount_uploader :image, ImageUploader

  end
end
