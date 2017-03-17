require 'sass-rails'
require 'coffee-rails'
require 'colorize'
require 'friendly_id'
require 'aasm'
require 'ffaker'
require 'simple_form'
require 'tinymce-rails'

module Binda
  class Engine < ::Rails::Engine
    isolate_namespace Binda

    # Add vendor files to pipeline
    config.assets.paths << config.root.join("vendor", "assets" )
    # config.assets.paths << config.root.join("vendor", "assets", "fonts")
    config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/

  end
end
