if defined?(CypressDev)
  CypressDev.configure do |c|
    c.cypress_folder = File.expand_path("#{__dir__}/../../spec/cypress")
    # WARNING!! CypressDev can execute arbitrary ruby code
    # please use with extra caution if enabling on hosted servers or starting your local server on 0.0.0.0
    c.use_middleware = Rails.env.test?
    c.logger = Rails.logger
  end
end