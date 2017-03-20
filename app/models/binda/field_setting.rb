module Binda
  class FieldSetting < ApplicationRecord

  	# Associations
  	belongs_to :field_group
  	has_many :texts, as: :fieldable

		# Validations
		validates :name, presence: true

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
