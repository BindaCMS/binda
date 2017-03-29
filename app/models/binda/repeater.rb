module Binda
  class Repeater < ApplicationRecord

  	# Associations
  	belongs_to :fieldable, polymorphic: true
  	belongs_to :field_setting
  	has_one :field_group

		# Validations

  	# Slug


		# CUSTOM METHODS
		# --------------

  end
end
