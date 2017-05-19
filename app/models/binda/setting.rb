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
	    slug.blank?
	  end

	  def self.website_name
	  	self.all.find { |s| s.slug == 'website-name' }
	  end

	  def self.website_description
	  	self.all.find { |s| s.slug == 'website-description' }
	  end

	  def self.maintenance_mode
	  	self.all.find { |s| s.slug == 'maintenance-mode' }
	  end

	  def self.is_maintenance_mode
	  	# maybe this should have question mark at the end...
	  	self.maintenance_mode.is_true
	  end

  end
end
