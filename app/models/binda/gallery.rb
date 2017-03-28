module Binda
  class Gallery < ApplicationRecord

  	# Associations
  	has_many :bindings
  	has_many :assets, through: :bindings
  	belongs_to :fieldable, polymorphic: true
  	belongs_to :field_setting
  	
		# Validations

  	# Slug

		# CUSTOM METHODS
		# --------------

  end
end
