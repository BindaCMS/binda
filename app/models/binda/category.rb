module Binda
  class Category < ApplicationRecord

  	# Associations
  	belongs_to :structure
  	has_and_belongs_to_many :pages

		# Validations
		validates :name, presence: true
		validates :publish_state, presence: true, inclusion: { in: %w( draft published )}

  	# Slug
		extend FriendlyId
		friendly_id :name, use: [:slugged, :finders]


		# CUSTOM METHODS
		# --------------
	  # https://github.com/norman/friendly_id/issues/436
	  def should_generate_new_friendly_id?
	    slug.blank? || name_changed?
	  end

  end
end
