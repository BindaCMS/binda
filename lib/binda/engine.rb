require 'devise'
require 'jquery-rails'
require 'jquery-ui-rails'
require 'sass-rails'
require 'friendly_id'
require 'aasm'
require 'simple_form'
require 'tinymce-rails'
require 'carrierwave'
require 'mini_magick'
require 'ancestry'
require 'kaminari'
require 'bourbon'

# **Binda** is a CMS with an intuitive out-of-the-box interface to manage and customize page components.
# 
# For more information check [Binda's guidelines](/docs/file/README.md)
module Binda
	class Engine < ::Rails::Engine
		isolate_namespace Binda

		# Add vendor files to pipeline
		config.assets.paths << config.root.join("vendor", "assets" )
		# config.assets.paths << config.root.join("vendor", "assets", "fonts")
		config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/

		# Setup tinymce configuration file
		config.tinymce.config_path = self.root.join("config/tinymce.yml")

		# https://stackoverflow.com/a/17718926/1498118
		config.generators do |g|
			g.integration_tool :rspec
			g.test_framework :rspec
		end
	end
end