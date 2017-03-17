module Binda
  class Setting < ApplicationRecord

	  # has_many :bindings
	  # has_many :assets, class_name: 'Admin::Asset', through: :bindings

		extend FriendlyId
		friendly_id :name, use: [:slugged, :finders]

	  # https://github.com/norman/friendly_id/issues/436
	  def should_generate_new_friendly_id?
	    slug.blank? || name_changed?
	  end

	  def self.website_name
	  	Setting.find_by(name: 'website_name').first
	  end

  end
end
