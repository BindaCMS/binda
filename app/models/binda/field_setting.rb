module Binda
  class FieldSetting < ApplicationRecord

  	# Associations
  	belongs_to :field_group

  	# Fields Associations 
  	# -------------------
  	# If you add a new field remember to update:
  	#   - get_fieldables (see here below)
  	#   - get_field_types (see here below)
  	#   - component_params (app/controllers/binda/components_controller.rb)
  	has_many :texts,         as: :fieldable
  	has_many :dates,         as: :fieldable
  	has_many :repeaters,     as: :fieldable
  	has_many :galleries,     as: :fieldable
  	has_many :assets,        as: :fieldable 
  	# The following direct association is used to securely delete associated fields
  	# Infact via `fieldable` the associated fields might not be deleted 
  	# as the fieldable_id is related to the `component` rather than the `field_setting`
  	has_many :texts,         dependent: :delete_all
  	has_many :dates,         dependent: :delete_all
  	has_many :repeaters,     dependent: :delete_all
  	has_many :galleries,     dependent: :delete_all


  	def self.get_fieldables
  		%w( Text Date Repeater Gallery Asset )
  	end

  	# Field types are't fieldable! watch out! They might use the same model (eg `string` and `text`)
	  def get_field_types
	  	%w( string text asset gallery repeater date )
	  end

		# Validations
		validates :name, presence: true
		validates :field_type, presence: true, inclusion: { in: :get_field_types }

  	# Slug
		extend FriendlyId
		friendly_id :default_slug, use: [:slugged, :finders]


		# CUSTOM METHODS
		# --------------
	  # https://github.com/norman/friendly_id/issues/436
	  def should_generate_new_friendly_id?
	    slug.blank?
	  end

	  def default_slug
	  	[ "#{ self.field_group.structure.name }-#{ self.field_group.name }-#{ self.name }",
	  		"#{ self.field_group.structure.name }-#{ self.field_group.name }-#{ self.name }-1",
	  		"#{ self.field_group.structure.name }-#{ self.field_group.name }-#{ self.name }-2",
	  		"#{ self.field_group.structure.name }-#{ self.field_group.name }-#{ self.name }-3" ]
	  end

  	# This will be use to overcome cascade delete on fieldable polymorphic association
  	# Infact fieldables aren't actually associated in the DB, they are associated with components!
  	# def self.get_deletable_fieldables
  	# 	self.get_fieldables - %w( Asset )
  	# end

  	# def delete_fieldables
  	# 	self.get_deletable_fieldables.each do |fieldable|
  	# 		F = fieldable.constantize
  	# 		F.where( field_setting_id:  )
  	# 	end
  	# end


  end
end
