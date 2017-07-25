module Binda
  class Choice < ApplicationRecord

  	belongs_to :field_setting
  	belongs_to :selectable, polymorphic: true, optional: true

		validates :label, presence: true
		validates :value, presence: true

  end
end
