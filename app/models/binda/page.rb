module Binda
  class Page < ApplicationRecord

  	# Associations
  	belongs_to :structure, required: true
  	has_and_belongs_to_many :categories
		has_many :texts,     as: :fieldable
		has_many :assets,    as: :fieldable
		has_many :galleries, as: :fieldable
		has_many :repeaters, as: :fieldable

		accepts_nested_attributes_for :structure, :categories, :texts, :assets, :galleries, :repeaters, allow_destroy: true

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
		# --------------
	  # https://github.com/norman/friendly_id/issues/436
	  def should_generate_new_friendly_id?
	    slug.blank? || name_changed?
	  end
	  
	  def get_text( field_slug )
	  	field_setting = Binda::FieldSetting.friendly.find( field_slug )
	  	self.texts.where( field_setting_id: field_setting.id ).first.content
	  end

	  def has_text( field_slug )
	  	field_setting = Binda::FieldSetting.friendly.find( field_slug )
	  	obj = self.texts.where( field_setting_id: field_setting.id )
	  	if obj.any?
	  		!obj.first.content.nil?
  		else
  			return false
  		end
	  end

	  def get_image_url( field_slug, size = '' )
	  	field_setting = Binda::FieldSetting.friendly.find( field_slug )
	  	obj = self.assets.where( field_setting_id: field_setting.id ).first.image
	  	if obj.respond_to?(size) && %w[thumb medium large].include?(size)
			  obj.send(size).url
			else
				obj.url
			end
	  end

	  def has_image( field_slug )
	  	field_setting = Binda::FieldSetting.friendly.find( field_slug )
	  	obj = self.assets.where( field_setting_id: field_setting.id )
	  	if obj.any?
	  		!obj.first.image.nil?
  		else
  			return false
  		end
	  end
 
  end
end
