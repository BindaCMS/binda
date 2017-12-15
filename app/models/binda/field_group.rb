module Binda
	class FieldGroup < ApplicationRecord

		# Associations
		belongs_to :structure

		# use destroy not delete_all otherwise the field settings 
		# won't be able to delete all their dependent content
		has_many :field_settings, dependent: :destroy

		# Validations
		validates :name, presence: true
		validates :slug, uniqueness: true
		accepts_nested_attributes_for :field_settings, allow_destroy: true, reject_if: :is_rejected

		# Slug
		extend FriendlyId
		friendly_id :default_slug, use: [:slugged, :finders]

		after_create :update_position

		# Friendly id preference on slug generation
		#
		# Method inherited from friendly id 
		# @see https://github.com/norman/friendly_id/issues/436
	  def should_generate_new_friendly_id?
	    slug.blank?
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

		#
		# Sets the validation rules to accept and save an attribute
		def is_rejected( attributes )
			attributes['name'].blank? && attributes['field_type'].blank?
		end

		private 

			def update_position
				if self.position.nil?
					self.update_attribute( 'position', self.structure.field_groups.length )
				end
			end

	end
end
