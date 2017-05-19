$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "binda/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "binda"
  s.version     = Binda::VERSION
  s.authors     = ["Alessandro Barbieri"]
  s.email       = ["alessandro@lacolonia.studio"]
  s.homepage    = "http://lacolonia.studio"
  s.summary     = "Binda CMS"
  s.description = "A dynamic CMS for Ruby on Rails 5, inspired by Spina"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails",                "~> 5.0.1"
  s.add_dependency "jquery-rails"
  s.add_dependency "jquery-ui-rails",      "~> 5.0.5"
  s.add_dependency "sass-rails",           "~> 5.0.6"
  s.add_dependency "coffee-rails",         "~> 4.2.1"
  s.add_dependency "colorize",             "~> 0.8.1"
  s.add_dependency "friendly_id",          "~> 5.1.0"
  s.add_dependency "aasm",                 "~> 4.11"
  s.add_dependency "ffaker",               "~> 2.5.0"
  s.add_dependency "simple_form",          "~> 3.3.1"
  s.add_dependency "tinymce-rails",        "~> 4.5.1"
  s.add_dependency "tinymce-rails-langs"
  s.add_dependency "devise",               "~> 4.1.1"
  s.add_dependency "carrierwave",          "~> 1.0"
  s.add_dependency "mini_magick",          "~> 4.5"
  s.add_dependency "ancestry",             "~> 2.1.0"
  # s.add_dependency "meta-tags"
  # s.add_dependency "cancancan"

  # s.add_development_dependency "sqlite3"
end
