module Binda
  class Page < ApplicationRecord

		has_many :fields, as: :fieldable

	  # has_many :bindings
	  # has_many :assets, class_name: 'Admin::Asset', through: :bindings

		extend FriendlyId
		friendly_id :name, use: [:slugged, :finders]

		include AASM

	  	aasm :column => 'publish_state' do
	      	state :draft, :initial => true
	      	state :published    

	    	event :is_published do
	      	transitions :from => :draft, :to => :published
	    	end

	    	event :is_draft do
	    	  transitions :from => :published, :to => :draft
	    	end

	  	end

		validates :name, presence: true
		# validates :position, uniqueness: true
		validates :publish_state, presence: true, inclusion: { in: %w( draft published )}

	  # https://github.com/norman/friendly_id/issues/436
	  def should_generate_new_friendly_id?
	    slug.blank? || name_changed?
	  end
	  
  end
end
