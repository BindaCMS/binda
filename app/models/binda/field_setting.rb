module Binda
  class FieldSetting < ApplicationRecord

  	# Associations
  	belongs_to :field_group
  	has_many :texts,     as: :fieldable
  	has_many :galleries, as: :fieldable
  	has_many :assets,    as: :fieldable
  	has_many :repeaters, as: :fieldable

		# Validations
		validates :name, presence: true
		validates :field_type, presence: true, inclusion: { in: %w( text asset gallery repeater )}

  	# Slug
		extend FriendlyId
		friendly_id :default_slug, use: [:slugged, :finders]


		# CUSTOM METHODS
		# --------------
	  # https://github.com/norman/friendly_id/issues/436
	  def should_generate_new_friendly_id?
	    slug.blank? || name_changed?
	  end

	  def default_slug
	  	[ "#{ self.field_group.name }-#{ self.name }",
	  		"#{ self.field_group.name }-#{ self.name }-1",
	  		"#{ self.field_group.name }-#{ self.name }-2",
	  		"#{ self.field_group.name }-#{ self.name }-3" ]
	  end

  end
end
