require 'friendly_id'
require 'aasm'

module Binda
  class Engine < ::Rails::Engine
    isolate_namespace Binda
  end
end
