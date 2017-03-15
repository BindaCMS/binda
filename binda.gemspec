$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "binda/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "binda"
  s.version     = Binda::VERSION
  s.authors     = ["Alessandro Barbieri"]
  s.email       = ["info@alessandrobarbieri.net"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Binda."
  s.description = "TODO: Description of Binda."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.1"

  s.add_development_dependency "sqlite3"
end
