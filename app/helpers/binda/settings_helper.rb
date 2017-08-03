module Binda
  module SettingsHelper

  	def get_website_name
  		Setting.friendly.find('dashboard').get_text('website-name')
  	end

  	def get_website_description
  		Setting.friendly.find('dashboard').get_text('website-description')
  	end

  end
end
