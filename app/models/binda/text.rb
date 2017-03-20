module Binda
  class Text < ApplicationRecord

  	# Associations
  	belongs_to :fieldable, polymorphic: true
  	belongs_to :field_setting

		# Validations

  	# Slug


		# CUSTOM METHODS
		# --------------
  	
  end
end
