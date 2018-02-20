module Binda
	class FieldGroup < ApplicationRecord

		# Associations
		belongs_to :structure

		# use destroy not delete_all otherwise the field settings 
		# won't be able to delete all their dependent content
		has_many :field_settings, dependent: :destroy

		# Validations
		validates :name, presence: {
			message: I18n.t("binda.field_group.validation_message.name")
		}
		validate :slug_uniqueness
		validates_associated :field_settings
		accepts_nested_attributes_for :field_settings, allow_destroy: true, reject_if: :is_rejected

		# Slug
		extend FriendlyId
		friendly_id :default_slug, use: [:slugged, :finders]

		after_create :set_default_position

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

		def slug_uniqueness
			record_with_same_slug = self.class.where(slug: slug)
			if record_with_same_slug.any? && !record_with_same_slug.ids.include?(id)
				errors.add(:slug, I18n.t("binda.field_group.validation_message.slug", { arg1: slug }))
				return false
			else
				return true
			end
		end

		private 

			# Set a default position if isn't set and updates all related field settings
			# Update all field settings related to the one created
			def set_default_position
				FieldGroup
					.where(structure_id: self.structure_id)
					.each{|field_group| field_group.increment(:position).save!}
			end

	end
end
