module Binda
	# This class provides support for uploading videos.
	class Audio < Asset

    mount_uploader :audio, AudioUploader
  end
end