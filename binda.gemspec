$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "binda/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "binda"
  s.version     = Binda::VERSION.dup
  s.authors     = ["Alessandro Barbieri"]
  s.email       = ["alessandro@lacolonia.studio"]
  s.homepage    = "http://lacolonia.studio"
  s.summary     = "Binda CMS"
  s.description = "A modular CMS for Ruby on Rails 5 with an intuitive out-of-the-box interface to manage and customize components. Use Binda if you want to speed up your setup process and concentrate directly on what your application is about. Please read the documentation for more information and a quick start guide."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib,vendor}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.required_ruby_version = '>= 2.3.1'


  # PRIMARY GEMS
  # ------------
  s.add_dependency "rails",                ">= 5.0",        "< 5.3"
  s.add_dependency "jquery-rails",         "~> 4.3"
  s.add_dependency "jquery-ui-rails",      ">= 5.0",        "< 6.1"
  s.add_dependency "sass-rails",           "~> 5.0"
  s.add_dependency "aasm",                 ">= 4.11",       "< 4.13"
  s.add_dependency "simple_form",          ">= 3.3", "< 5.1"
  s.add_dependency "tinymce-rails",        ">= 4.1",        "<= 4.8"
  s.add_dependency "tinymce-rails-langs",  "~> 4.20160310"
  s.add_dependency "devise",               ">= 4.1",        "< 4.5"
  s.add_dependency "devise-i18n",          "~> 1.4"
  s.add_dependency "carrierwave",          ">= 0.10", "< 2.2"
  s.add_dependency "mini_magick",          ">= 4.5",        "< 4.9"
  s.add_dependency "ancestry",             ">= 2.1",        "< 3.1"
  s.add_dependency "kaminari",             "~> 1.0"
  s.add_dependency "friendly_id",          ">= 5.1",        "< 5.4"
  s.add_dependency "bourbon",              "4.3.4"


  # DEVELOPMENT GEMS
  # ----------------
  s.add_development_dependency "listen",                      "~> 3.1"
  s.add_development_dependency "pg",                          ">= 0.21", "< 1.0"
  s.add_development_dependency "pry-rails",                   "~> 0.3.5"
  s.add_development_dependency "rspec-rails",                 ">= 3.5",  "< 3.8"
  s.add_development_dependency "autoprefixer-rails",          "~> 7.1",  "< 8"
  s.add_development_dependency "capybara",                    ">= 2.14", "< 3"
  s.add_development_dependency "selenium-webdriver",          "~> 3.5",  "< 4"
  s.add_development_dependency "factory_bot_rails",           "~> 4.8"
  s.add_development_dependency "database_cleaner",            ">= 1.6",  "< 2"
  s.add_development_dependency "yard",                        "> 0.9.11", "< 1.0"
  s.add_development_dependency "yard-activesupport-concern",  "~> 0.0.1", "< 0.1"
  s.add_development_dependency "bullet",                      ">= 5.6", "< 6"
  s.add_development_dependency "redcarpet",                   "~> 3.4"
  s.add_development_dependency "github-markup",               ">= 1.6", "< 2.1"
  s.add_development_dependency "travis",                      "~> 1.8"
  s.add_development_dependency "rubocop",                     "~> 0.52.1"
  s.add_development_dependency "mry",                         "~> 0.52"
  s.add_development_dependency "generator_spec",              "~> 0.9.4"

end
