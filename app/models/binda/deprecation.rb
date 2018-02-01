module Binda
	class Deprecation < ActiveSupport::Deprecation
		def initialize(deprecation_horizon = 'next major release', gem_name = 'Binda')
			super
		end
	end
end