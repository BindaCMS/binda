module Binda
	class Component < ApplicationRecord

		include ComponentModelHelper

		# Associations
		belongs_to :structure, required: true
		has_and_belongs_to_many :categories
		has_many :texts,      as: :fieldable, dependent: :delete_all
		has_many :dates,      as: :fieldable, dependent: :delete_all
		has_many :galleries,  as: :fieldable, dependent: :delete_all
		has_many :assets,     as: :fieldable, dependent: :delete_all 
		has_many :radios,     as: :fieldable, dependent: :delete_all 
		has_many :selects,    as: :fieldable, dependent: :delete_all 
		has_many :checkboxes, as: :fieldable, dependent: :delete_all 
		# Repeaters need destroy_all, not delete_all
		has_many :repeaters, as: :fieldable, dependent: :destroy


		accepts_nested_attributes_for :structure, :categories, :texts, :dates, :assets, :galleries, :repeaters, :radios, :selects, :checkboxes, allow_destroy: true

		cattr_accessor :field_settings_array

		# has_many :bindings
		# has_many :assets, class_name: 'Admin::Asset', through: :bindings

		# Validations
		validates :name, presence: true
		validates :slug, uniqueness: true
		validates :publish_state, presence: true, inclusion: { in: %w( draft published )}

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


		# CUSTOM METHODS
		# 
		# @see https://github.com/norman/friendly_id/issues/436
		def should_generate_new_friendly_id?
			slug.blank?
		end
 
	end
end
