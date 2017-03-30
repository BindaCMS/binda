module Binda
  class FieldGroup < ApplicationRecord

  	# Associations
  	belongs_to :structure
  	belongs_to :repeater
  	has_many :field_settings

		# Validations
		validates :name, presence: true
		validates :slug, uniqueness: true
		accepts_nested_attributes_for :field_settings, allow_destroy: true

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
