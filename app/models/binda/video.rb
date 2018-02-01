module Binda
	# This class provides support for uploading videos.
	class Video < Asset

    mount_uploader :video, VideoUploader

	end
end