module Binda
	class FieldGroup < ApplicationRecord

		# Associations
		belongs_to :structure

		# use destroy not delete_all otherwise the field settings 
		# won't be able to delete all their dependent content
		has_many :field_settings, dependent: :delete_all

		# Validations
		validates :name, presence: true
		validates :slug, uniqueness: true
		accepts_nested_attributes_for :field_settings, allow_destroy: true, reject_if: :is_rejected
		
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
			[ "#{ self.structure.name }-#{ self.name }",
				"#{ self.structure.name }-#{ self.name }-1",
				"#{ self.structure.name }-#{ self.name }-2",
				"#{ self.structure.name }-#{ self.name }-3" ]
		end

		def is_rejected( attributes )
			attributes['name'].blank? && attributes['field_type'].blank?
		end

	end
end
