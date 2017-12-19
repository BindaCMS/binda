module Binda
	class Selection < ApplicationRecord

		has_and_belongs_to_many :choices
		belongs_to :field_setting

		# after_create :set_choice

		# Set the default choice if selection can't be empty.
		# This method run after the record is created and generates a default choice
		#   if the user hasn't created already one.
		# def set_choice
		# 	return if self.field_setting.allow_null
		# 	if self.field_setting.default_choice_id.nil?
		# 		default = self.field_setting.choices.create!( label: 'default', value: 'default' )
		# 		self.field_setting.update_attributes(default_choice_id: default.id)
		# 	end
		# 	self.choices << Choice.find(self.field_setting.default_choice_id) if self.choices.empty?
		# end

	end
end