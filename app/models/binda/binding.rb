module Binda
  class Binding < ApplicationRecord

  	# Associations
  	belongs_to :asset
  	belongs_to :gallery

		# Validations
		validates :name, presence: true

  	# Slug
		extend FriendlyId
		friendly_id :name, use: [:slugged, :finders]


		# CUSTOM METHODS
		# --------------
	  # https://github.com/norman/friendly_id/issues/436
	  def should_generate_new_friendly_id?
	    slug.blank?
	  end

  end
end
