module Binda
  class Choice < ApplicationRecord

  	belongs_to :field_setting
  	has_and_belongs_to_many :selects

		validates :label, presence: true
		validates :value, presence: true

  end
end
