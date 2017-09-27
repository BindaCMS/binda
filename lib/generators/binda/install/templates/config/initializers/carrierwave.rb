CarrierWave.configure do |config|
  config.storage = :file


  # # If you prefer to use Google uncomment and udpate the following lines
  # # Make sure you read this before the setup
  # # https://github.com/carrierwaveuploader/carrierwave#using-google-storage-for-developers
  # config.fog_provider = 'fog/google'                        # required
  # config.fog_credentials = {
  #   provider:                 'Google',
  #   google_project:           '',
  #   google_client_email:      '',
  #   google_json_key_location: ''
  # }
  # # config.storage must go after config.fog_credentials
  # # https://github.com/carrierwaveuploader/carrierwave/issues/2023#issuecomment-252407542
  # config.storage = :fog
  # config.fog_directory = ''


  # # If you prefer to use S3 uncomment and udpate the following lines
  # config.fog_credentials = {
  #   provider:               'AWS',
  #   region:                 '',
  #   aws_access_key_id:      '',
  #   aws_secret_access_key:  ''
  # }
  # # config.storage must go after config.fog_credentials
  # # https://github.com/carrierwaveuploader/carrierwave/issues/2023#issuecomment-252407542
  # config.storage = :fog
  # config.fog_directory  = ''
  # config.fog_public     = true
  # config.fog_attributes = { 'Cache-Control' => 'max-age=315576000' }


  # # Enable this line if you are using Heroku
  # config.cache_dir = "#{Rails.root}/tmp/uploads"


  config.enable_processing = !Rails.env.test?
end