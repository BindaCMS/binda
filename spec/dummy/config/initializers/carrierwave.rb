CarrierWave.configure do |config|
  config.storage = :file

  # # Use Google if you want
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

  # # Use S3 if you want
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

  config.enable_processing = !Rails.env.test?
end