module Binda
	# This class provides support for dates.
  class Date < ApplicationRecord

    include Fields
    include FieldUniqueness
		
  end
end
