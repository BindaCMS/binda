module Binda
  class Category < ApplicationRecord

  	# Associations
  	belongs_to :structure
  	has_and_belongs_to_many :pages

		# Validations
		validates :name, presence: true

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
	  	[ "#{ self.structure.name }-#{ self.name }",
	  		"#{ self.structure.name }-#{ self.name }-1",
	  		"#{ self.structure.name }-#{ self.name }-2",
	  		"#{ self.structure.name }-#{ self.name }-3" ]
	  end

  end
end
