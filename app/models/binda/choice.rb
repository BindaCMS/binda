module Binda
  class Choice < ApplicationRecord

  	belongs_to :field_setting
  	has_and_belongs_to_many :selections

		validates :label, presence: true
		validates :value, presence: true
		validates :field_setting_id, presence: true

		after_create :set_default_choice
		after_destroy :reset_default_choice

		# In order to make sure that a default choice is set, this method is executed after
		#   the first choice is associated to the field setting. What does it do? 
		#   If there isn't a default it sets the current choice as the default one.
		#   The method is executed as well if new choices are added.
		def set_default_choice
			unless self.field_setting.default_choice.present?
				self.field_setting.default_choice_id = self.id
				unless self.field_setting.save
					raise ArgumentError "It hasn't been possible to set the default choice for the current setting."
				end
			end
		end

		# In order to make sure that a default choice is set, this method is executed after the 
		#   default choice is removed. What does it do? If the removed choice is the default one it sets
		#   another defautl picking the first of the choices associated by id.
		#   The method is executed as well on every time a choice is removed.
		def reset_default_choice
			if self.field_setting.default_choice_id == self.id && self.field_setting.choices.any?
				self.field_setting.default_choice_id = self.field_setting.choices.first.id
				unless self.field_setting.save
					raise ArgumentError "It hasn't been possible to set the default choice for the current setting."
				end
			end
		end

  end
end
