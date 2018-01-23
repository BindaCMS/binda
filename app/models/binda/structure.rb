module Binda
	class Structure < ApplicationRecord

		# Associations
		has_many :components, dependent: :destroy
		has_one  :board, dependent: :destroy
		has_many :categories, dependent: :destroy
		has_many :field_groups, dependent: :destroy

		has_and_belongs_to_many :field_settings

		# Validations
		validates :name, presence: true
		validates :slug, uniqueness: true
		validates_associated :field_groups
		validates :instance_type, presence: true, inclusion: { 
			in: %w(component board), 
			message: I18n.t('binda.structure.validation_message.instance_type', { arg1: "%{value}" })
		}
		accepts_nested_attributes_for :field_groups, allow_destroy: true, reject_if: :is_rejected

		# Slug
		extend FriendlyId
		friendly_id :default_slug, use: [:slugged, :finders]

		after_create :add_default_field_group
		after_create :add_instance_details
		after_create :set_default_position

		# Friendly id preference on slug generation
		#
		# Method inherited from friendly id 
		# @see https://github.com/norman/friendly_id/issues/436
		def should_generate_new_friendly_id?
			slug.blank?
		end

		#
		# Sets the validation rules to accept and save an attribute
		def is_rejected( attributes )
			attributes['name'].blank?
		end

		# Set slug name
		#
		# It generates 4 possible slugs before falling back to FriendlyId default behaviour
		def default_slug
			[ "#{ self.name }",
				"#{ self.name }-1",
				"#{ self.name }-2",
				"#{ self.name }-3" ]
		end

		# Add a field group as a default
		# 
		# In order to speed up the setup process Binda will automatically provide a 
		#   field group called 'General Details' after the structure is created.
		# @return [redirect]
		def add_default_field_group
			# Creates a default empty field group 
			field_group = self.field_groups.build(name: I18n.t('binda.default_field_group.name'), position: 1)
			# Unless there is a problem...
			unless field_group.save
				return redirect_to structure_path(self.slug), flash: { error: I18n.t('binda.default_field_group.error_on_create') }
			end
		end

		# Add details based on instance type
		# 
		# If instance_type is set to 'setting' it generates a default Binda::Setting instance after creation. 
		#   The generated instance will be associated to the structure and named after it.
		#   It also disable categories (this could be a different method, or method could be more explicit)
		def add_instance_details
			if self.instance_type == 'board'
				self.update_attribute('has_categories', false)
				board = self.build_board( name: self.name )
				unless board.save
					return redirect_to structure_path(self.slug), flash: { error: I18n.t('binda.default_field_group.error_on_create') }
				end
			end
		end

		# Set default position after create
		# 
		# This methods ensure that every repeater instance has an explicit position.
		#   The latest repeater created gets the highest position number.
		# 
		# @return [object] Repeater instance
		def set_default_position
				position = Structure.all.length
				self.update_attribute 'position', position
		end

	end
end
