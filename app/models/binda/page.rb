module Binda
  class Page < ApplicationRecord

  	# Associations
  	belongs_to :structure
  	has_and_belongs_to_many :categories
		has_many :texts, as: :fieldable

	  # has_many :bindings
	  # has_many :assets, class_name: 'Admin::Asset', through: :bindings

		# Validations
		validates :name, presence: true
		validates :publish_state, presence: true, inclusion: { in: %w( draft published )}

  	# Slug
		extend FriendlyId
		friendly_id :name, use: [:slugged, :finders]

		# Publish state behaviour
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


		# CUSTOM METHODS
		# --------------
	  # https://github.com/norman/friendly_id/issues/436
	  def should_generate_new_friendly_id?
	    slug.blank? || name_changed?
	  end
	  
	  def get_text( field_slug )
	  	field_setting = Binda::FieldSetting.friendly.find( field_slug )
	  	self.texts.where({ 'field_setting_id': field_setting.id }).first
	  end
  end
end
