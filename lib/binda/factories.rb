GEM_ROOT = File.dirname(File.dirname(File.dirname(__FILE__)))
Dir[File.join(GEM_ROOT, 'spec', 'factories', '*.rb')].each { |file| require(file) }

