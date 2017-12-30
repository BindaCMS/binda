module Binda
  class Board < ApplicationRecord

  	include FieldableAssociations

		belongs_to :structure, required: true

		validates :name, presence: true
		validates :slug, uniqueness: true

		# Slug
		extend FriendlyId
		friendly_id :name, use: [:slugged, :finders]

		# Friendly id preference on slug generation
		#
		# Method inherited from friendly id 
		# @see https://github.com/norman/friendly_id/issues/436
		def should_generate_new_friendly_id?
			slug.blank?
		end

  end
end