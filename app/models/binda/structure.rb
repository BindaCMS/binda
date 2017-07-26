module Binda
	class Structure < ApplicationRecord

		# Associations
		has_many :components
		has_many :categories
		has_many :field_groups

		# Validations
		validates :name, presence: true
		validates :slug, uniqueness: true
		accepts_nested_attributes_for :field_groups, allow_destroy: true, reject_if: :is_rejected

		# Slug
		extend FriendlyId
		friendly_id :name, use: [:slugged, :finders]


		# CUSTOM METHODS
		# --------------
		# https://github.com/norman/friendly_id/issues/436
		def should_generate_new_friendly_id?
			slug.blank?
		end

		def is_rejected( attributes )
			attributes['name'].blank?
		end

	end
end
