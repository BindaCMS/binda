module Binda
  class Board < ApplicationRecord

  	include FieldableAssociations

		# source: :children_fieldable matches with the belong_to :children_fieldable identification in the Association model
		has_many :children_fieldables, through: :passive_relationships, source_type: "Binda::Board"
		# source: :parent_fieldable matches with the belong_to :children_fieldable identification in the Association model
		has_many :parent_fieldables, through: :active_relationships, source_type: "Binda::Board"

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

	  # def self.website_name
	  # 	self.all.find { |s| s.slug == 'website-name' }
	  # end

	  # def self.website_description
	  # 	self.all.find { |s| s.slug == 'website-description' }
	  # end

	  # def self.maintenance_mode
	  # 	self.all.find { |s| s.slug == 'maintenance-mode' }
	  # end

	  # def self.is_maintenance_mode
	  # 	# maybe this should have question mark at the end...
	  # 	self.maintenance_mode.is_true
	  # end

  end
end