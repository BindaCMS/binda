module Binda
	class Structure < ApplicationRecord

		# Associations
		has_many :components
		has_one  :setting
		has_many :categories
		has_many :field_groups

		# Validations
		validates :name, presence: true
		validates :slug, uniqueness: true
		accepts_nested_attributes_for :field_groups, allow_destroy: true, reject_if: :is_rejected

		# Slug
		extend FriendlyId
		friendly_id :default_slug, use: [:slugged, :finders]

		after_create :add_default_field_group

		# Friendly id preference on slug generation
		#
		# Method inherited from friendly id 
		# @see https://github.com/norman/friendly_id/issues/436
	  def should_generate_new_friendly_id?
	    slug.blank? || name_changed?
	  end

		#
		# Sets the validation rules to accept and save an attribute
		def is_rejected( attributes )
			attributes['name'].blank?
		end

		# Set slug name
		#
		# It generates 4 possible slugs before falling back to FriendlyId default behaviour
		def default_slug
			[ "#{ self.name }",
				"#{ self.name }-1",
				"#{ self.name }-2",
				"#{ self.name }-3" ]
		end

		def add_default_field_group
      # Creates a default empty field group 
      @field_group = self.field_groups.build( name: 'General Details', position: 1 )
      # Unless there is a problem...
      unless @field_group.save
        return redirect_to structure_path( self.slug ), flash: { error: 'General Details group hasn\'t been created' }
      end
    end

	end
end
