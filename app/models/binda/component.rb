module Binda
	class Component < ApplicationRecord

		include FieldableAssociations

		# Associations
		belongs_to :structure, required: true
		has_and_belongs_to_many :categories

		# Validations
		# validates :name, presence: true
		validates :slug, uniqueness: true
		validates :publish_state, presence: true, inclusion: { in: %w( draft published )}

		accepts_nested_attributes_for :categories, allow_destroy: true

		# Slug
		extend FriendlyId
		friendly_id :name, use: [:slugged, :finders]

		# Publish state behaviour
		include AASM

			aasm :column => 'publish_state' do
					state :draft, initial: true
					state :published    

				event :publish do
					transitions from: :draft, to: :published
				end

				event :unpublish do
					transitions from: :published, to: :draft
				end

			end

		# Friendly id preference on slug generation
		#
		# Method inherited from friendly id 
		# @see https://github.com/norman/friendly_id/issues/436
		def should_generate_new_friendly_id?
			slug.blank?
		end

	end
end
