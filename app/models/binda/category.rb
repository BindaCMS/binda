module Binda
  class Category < ApplicationRecord

  	# Associations
  	belongs_to :structure
  	has_and_belongs_to_many :components

		# Validations
		validates :name, presence: true
		validates :structure_id, presence: true

  	# Slug
		extend FriendlyId
		friendly_id :default_slug, use: [:slugged, :finders]


		# Friendly id preference on slug generation
		#
		# Method inherited from friendly id 
		# @see https://github.com/norman/friendly_id/issues/436
	  def should_generate_new_friendly_id?
	    slug.blank? || name_changed?
	  end

		# Set slug name
		#
		# It generates 4 possible slugs before falling back to FriendlyId default behaviour
	  def default_slug
	  	[ "#{ self.structure.name }-#{ self.name }",
	  		"#{ self.structure.name }-#{ self.name }-1",
	  		"#{ self.structure.name }-#{ self.name }-2",
	  		"#{ self.structure.name }-#{ self.name }-3" ]
	  end

  end
end
