module Binda
	# This class provides support for dates.
  class Date < ApplicationRecord

  	# Associations
  	belongs_to :fieldable, polymorphic: true
  	belongs_to :field_setting

		validates :fieldable_id, presence: true
		validates :fieldable_type, presence: true
		
  end
end
