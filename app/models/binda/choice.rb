module Binda
  class Choice < ApplicationRecord

  	belongs_to :field_setting

		validates :label, presence: true
		validates :content, presence: true

  end
end
