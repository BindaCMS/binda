module Binda
  class Setting < ApplicationRecord

  	# Associations
	  # has_many :bindings
	  # has_many :assets, class_name: 'Admin::Asset', through: :bindings

		# Validations
		validates :name, presence: true


  	# Slug
		extend FriendlyId
		friendly_id :name, use: [:slugged, :finders]


		# CUSTOM METHODS
		# --------------
	  # https://github.com/norman/friendly_id/issues/436
	  def should_generate_new_friendly_id?
	    slug.blank? || name_changed?
	  end

	  def self.website_name
	  	self.friendly.find('website-name')
	  end

	  def self.website_description
	  	self.friendly.find('website-description')
	  end

	  def self.maintenance_mode
	  	self.friendly.find('maintenance-mode')
	  end

	  def self.is_maintenance_mode
	  	self.friendly.find('maintenance-mode').is_true
	  end

  end
end
