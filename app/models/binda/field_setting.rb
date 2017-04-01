module Binda
  class FieldSetting < ApplicationRecord

  	# Associations
  	belongs_to :field_group

  	# Fields Associations 
  	# -------------------
  	# If you add a new field remember to update:
  	#   - type_of_fields method (see here below)
  	#   - pages controller page_params method
  	has_many :texts,     as: :fieldable
  	has_many :galleries, as: :fieldable
  	has_many :assets,    as: :fieldable
  	has_many :repeaters, as: :fieldable
  	has_many :dates,     as: :fieldable


		# Validations
		validates :name, presence: true
		validates :field_type, presence: true, inclusion: { in: :type_of_fields }

  	# Slug
		extend FriendlyId
		friendly_id :default_slug, use: [:slugged, :finders]


		# CUSTOM METHODS
		# --------------
	  # https://github.com/norman/friendly_id/issues/436
	  def should_generate_new_friendly_id?
	    slug.blank?
	  end

	  def default_slug
	  	[ "#{ self.field_group.structure.name }-#{ self.field_group.name }-#{ self.name }",
	  		"#{ self.field_group.structure.name }-#{ self.field_group.name }-#{ self.name }-1",
	  		"#{ self.field_group.structure.name }-#{ self.field_group.name }-#{ self.name }-2",
	  		"#{ self.field_group.structure.name }-#{ self.field_group.name }-#{ self.name }-3" ]
	  end

	  def type_of_fields
	  	%w( string text asset gallery repeater date )
	  end

	  def self.type_of_fields
	  	type_of_fields
	  end


  end
end
