module Binda
  class Board < ApplicationRecord

  	include FieldableAssociations

		belongs_to :structure, required: true

		validates :name, presence: true
		validates :slug, uniqueness: true

		# Slug
		extend FriendlyId
		friendly_id :name, use: [:slugged, :finders]

		# Friendly id preference on slug generation
		#
		# Method inherited from friendly id 
		# @see https://github.com/norman/friendly_id/issues/436
		def should_generate_new_friendly_id?
			slug.blank?
		end

		def self.remove_orphans
			Board
				.includes(:structure)
				.where(binda_structures: {id: nil})
				.each do |b|
				b.destroy!
				puts "Binda::Board with id ##{b.id} successfully destroyed"
			end
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

  end
end