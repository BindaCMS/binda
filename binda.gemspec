$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "binda/version"

require "binda/description"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "binda"
  s.version     = Binda::VERSION
  s.authors     = ["Alessandro Barbieri"]
  s.email       = ["alessandro@lacolonia.studio"]
  s.homepage    = "http://lacolonia.studio"
  s.summary     = "Binda CMS"
  s.description = Binda::DESCRIPTION
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib,vendor}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  # PRIMARY GEMS
  # ------------
  s.add_dependency "rails",                ">= 5.0",      "< 5.2"
  s.add_dependency "jquery-rails",         "~> 4.3"
  s.add_dependency "jquery-ui-rails",      ">= 5.0",      "< 6.1"
  s.add_dependency "sass-rails",           "~> 5.0"
  s.add_dependency "coffee-rails",         ">= 4.1",      "< 4.3"
  s.add_dependency "aasm",                 ">= 4.11",     "< 4.13"
  s.add_dependency "simple_form",          ">= 3.3",      "< 3.6"
  s.add_dependency "tinymce-rails",        ">= 4.1",      "< 4.7"
  s.add_dependency "tinymce-rails-langs",  "~> 4.20160310"
  s.add_dependency "devise",               ">= 4.1",      "< 4.4"
  s.add_dependency "carrierwave",          ">= 0.10",     "< 1.12"
  s.add_dependency "mini_magick",          ">= 4.5",      "< 4.8"
  s.add_dependency "ancestry",             ">= 2.1",      "< 3.1"
  # s.add_dependency "meta-tags"
  # s.add_dependency "cancancan"


  # SECONDARY GEMS
  # --------------
  # The following gems could be avoided and they'll soon or late be discarded
  s.add_dependency "colorize",             "~> 0.8"
  s.add_dependency "ffaker",               "~> 2.5"
  s.add_dependency "friendly_id",          ">= 5.1",      "< 5.3"


  # DEVELOPMENT GEMS
  # ----------------
  s.add_development_dependency "listen",                   "~> 3.1"
  s.add_development_dependency "pg",                       "~> 0.21"
  s.add_development_dependency "pry-rails",                "~> 0.3.5"
  s.add_development_dependency "rspec-rails",              ">= 3.5",       "< 3.7"
  s.add_development_dependency "autoprefixer-rails",       "~> 7.1"
  s.add_development_dependency "capybara",                 "~> 2.14"
  s.add_development_dependency "factory_girl_rails",       "~> 4.8"
  s.add_development_dependency "database_cleaner",         "~> 1.6"
  s.add_development_dependency "yard",                     "~> 0.9"
  
end
