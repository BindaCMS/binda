module Binda
	class Selection < ApplicationRecord

		has_and_belongs_to_many :choices
		belongs_to :field_setting

		after_create :set_choice

		# Set the default choice if the field must have at least one.
		# This method run after the record is created.
		def set_choice
			return if self.field_setting.allow_null
			self.choices << self.field_setting.default_choice if self.choices.empty?
		end

	end
end