module Binda
	class Component < ApplicationRecord

		include FieldableAssociations

		# Associations

		belongs_to :structure, required: true
		has_and_belongs_to_many :categories

		# Validations
		validates :name, presence: true
		validates :slug, uniqueness: true
		validates :publish_state, presence: true, inclusion: { in: %w( draft published )}

		accepts_nested_attributes_for :categories, allow_destroy: true

		after_create :set_default_position
		after_create :create_field_instances

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

    # Create field instances for the current component
    def create_field_instances
    	instance_field_settings = FieldSetting
    		.includes(field_group: [ :structure ])
    		.where(binda_structures: { id: self.structure.id })
    	instance_field_settings.each do |field_setting|
    		field_setting.create_field_instance_for(self)
    	end
		end

		def self.remove_orphans
			Component
				.includes(:structure)
				.where(binda_structures: {id: nil})
				.each do |c|
					c.destroy!
					puts "Binda::Component with id ##{c.id} successfully destroyed"
				end
		end

		private

			def set_default_position
				Component
					.where(structure_id: self.structure_id)
					.update_all('position = position + 1')
			end

	end
end
