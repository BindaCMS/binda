module Binda
  class Page < ApplicationRecord

  	# Associations
  	belongs_to :structure, required: true
  	has_and_belongs_to_many :categories
		has_many :texts,     as: :fieldable, dependent: :delete_all
		has_many :dates,     as: :fieldable, dependent: :delete_all
		has_many :repeaters, as: :fieldable, dependent: :delete_all
		has_many :galleries, as: :fieldable, dependent: :delete_all
		has_many :assets,    as: :fieldable, dependent: :delete_all

		accepts_nested_attributes_for :structure, :categories, :texts, :dates, :assets, :galleries, :repeaters, allow_destroy: true

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
		# --------------
	  # https://github.com/norman/friendly_id/issues/436
	  def should_generate_new_friendly_id?
	    slug.blank?
	  end
	  
	  def get_text( field_slug )
	  	# Get the object related to that field setting
	  	obj = self.texts.detect{ |t| t.field_setting_id == get_field_setting_id( field_slug ) }.content
	  end

	  def has_text( field_slug )
	  	# Get the object related to that field setting
	  	obj = self.texts.detect{ |t| t.field_setting_id == get_field_setting_id( field_slug ) }
	  	if obj.present?
	  		!obj.content.nil?
  		else
  			return false
  		end
	  end

	  def has_image( field_slug )
	  	# Check if the field has an attached image
	  	obj = self.assets.detect{ |t| t.field_setting_id == get_field_setting_id( field_slug ) }.image.present?
	  end

	  def get_image_url( field_slug, size = '' )
	  	self.class.benchmark("Get image info (url)") do
		  	get_image_info( field_slug, size, 'url' )
		  end
	  end

	  def get_image_path( field_slug, size = '' )
	  	self.class.benchmark("Get image info (path)") do
		  	get_image_info( field_slug, size, 'path' )
		  end
	  end

	  def get_image_info( field_slug, size, info )
	  	# Get the object related to that field setting
	  	self.class.benchmark("Get field setting id") do
		  	obj = self.assets.detect{ |t| t.field_setting_id == get_field_setting_id( field_slug ) }
		  end
	  	self.class.benchmark("Check if image is present") do
	  		pr = obj.image.present?
	  	end
	  	self.class.benchmark("Check if file exists") do
	  		ex = obj.image.file.exists?
	  	end
  		# if obj.image.present? && obj.image.file.exists?
  		if pr && ex
		  	self.class.benchmark("Check if image respond to size") do
		  		re = obj.image.respond_to?(size)
		  	end
		  	self.class.benchmark("Check if size is in array") do
			  	ar = %w[thumb medium large].include?(size)
		  	end
		  	# if obj.image.respond_to?(size) && %w[thumb medium large].include?(size)
		  	if re && ar
			  	self.class.benchmark("get resized image") do
					  obj.image.send(size).send(info)
					end
				else
			  	self.class.benchmark("get default image") do
						obj.image.send(info)
					end
				end
			end
	  end

	  def has_date( field_slug )
	  	# Check if the field has an attached date
	  	obj = self.dates.detect{ |t| t.field_setting_id == get_field_setting_id( field_slug ) }
	  	if obj.present?
	  		!obj.date.nil?
  		else
  			return false
  		end
	  end

	  def get_date( field_slug )
	  	# Get the object related to that field setting
	  	obj = self.dates.detect{ |t| t.field_setting_id == get_field_setting_id( field_slug ) }.date
	  end

	  private 

		  def get_field_setting_id( field_slug )
		  	# Get field setting id from slug, without multiple calls to database 
		  	# (the query runs once and caches the result, then any further call uses the cached result)
				@@field_settings_array = Binda::FieldSetting.all if @@field_settings_array.nil?
				@@field_settings_array.detect { |fs| fs.slug == field_slug }.id
		  end
 
  end
end
