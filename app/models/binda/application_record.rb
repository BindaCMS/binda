# require deprecations list which can be found in app/models/concerns/binda/deprecations.rb
require 'binda/deprecations'

module Binda
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end