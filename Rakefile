begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Binda'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# https://www.viget.com/articles/rails-engine-testing-with-rspec-capybara-and-factorygirl/
# Dir[File.join(File.dirname(__FILE__), 'tasks/**/*.rake')].each {|f| load f }
# require 'rspec/core'

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'


load 'rails/tasks/statistics.rake'


require 'bundler/gem_tasks'


# This should ensure creation of spec instead of test (partially true)
# https://stackoverflow.com/a/4632188/1498118
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new('spec')
# If you want to make this the default task
task default: :spec