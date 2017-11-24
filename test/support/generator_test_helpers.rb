require 'pry'

module GeneratorTestHelpers
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def test_path
      File.join(File.dirname(__FILE__), "../../..")
    end

    def create_generator_sample_app  
      FileUtils.rm_rf(Rails.root.join('db/migrate'))
      FileUtils.rm_rf(Rails.root.join('db/schema.rb'))
      # FileUtils.cd(test_path) do
        # system "rails new binda_tmp_dummy --skip-test-unit --skip-spring --quiet --database=postgresql"
      # end
    end

    def remove_generator_sample_app
      # FileUtils.cd("#{test_path}/binda_tmp_dummy") do
      # exec "rails db:drop RAILS_ENV=test && rails db:create RAILS_ENV=test"
      # end
      # FileUtils.rm_rf("#{test_path}/binda_tmp_dummy")
    end
  end
end