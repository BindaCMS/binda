module Binda
  class Asset < ApplicationRecord

  	# Associations
  	belongs_to :fieldable, polymorphic: true
  	belongs_to :field_setting

  	validates :fieldable_id, presence: {
  		message: I18n.t('binda.asset.validation_message.fieldable_id', { arg1: self.class.name })
		}
		validates :field_setting_id, presence: {
			message: I18n.t('binda.asset.validation_message.field_setting_id', { arg1: self.class.name })
		}

  end
end