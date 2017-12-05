# see: https://til.codes/testing-carrierwave-file-uploads-with-rspec-and-factorygirl/
# This apparently doesn't work... needs further investigation
if Rails.env.test? || Rails.env.cucumber?

  # Setup Carrierwave to use local storage and disable file processing in test env
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end

  # Separate out the upload folders for test environment.
  CarrierWave::Uploader::Base.descendants.each do |klass|
    next if klass.anonymous?
    klass.class_eval do
      def cache_dir
        "#{Binda::Engine.root}/spec/support/uploads/tmp"
      end

      def store_dir
        "#{Binda::Engine.root}/spec/support/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end
    end
  end

  # Setting asset_host
  # (this line should stay outside the initial if statement)
  CarrierWave::Uploader::Base.descendants.each do |klass|
  	# Set the asset_host option for the carrierwave. 
    config.asset_host = ActionController::Base.asset_host
  end

end
