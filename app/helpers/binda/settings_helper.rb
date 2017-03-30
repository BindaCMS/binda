module Binda
  module SettingsHelper

  	def get_website_name
  		Setting.friendly.find('website-name').content
  	end

  	def get_website_description
  		Setting.friendly.find('website-description').content
  	end

  end
end
