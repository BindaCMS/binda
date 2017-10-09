module Binda
	class Component < ApplicationRecord

		include FieldableAssociations

		# Associations
		belongs_to :structure, required: true
		has_and_belongs_to_many :categories

		# Validations
		# validates :name, presence: true # TODO: check this, shouldn't be enabled?
		validates :slug, uniqueness: true
		validates :publish_state, presence: true, inclusion: { in: %w( draft published )}

		accepts_nested_attributes_for :categories, allow_destroy: true

		after_create :set_position

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

		# The limit above which componets cannot be sorted anymore
		def self.sort_limit
			1000 
		end

		private 

			# By default a newly created component gets the last position
	    def set_position
	    	# check whats the latest component
	    	last_position = self.structure.components.order(:position).pluck(:position).last
	    	# if latest component position isn't set get position by counting the amount of components
	    	last_position = self.structure.components.length if last_position.nil?
	    	# update component
	      self.update_attributes(position: last_position + 1)
	    end

	end
end
