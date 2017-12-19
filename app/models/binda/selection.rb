module Binda
	class Selection < ApplicationRecord

		has_and_belongs_to_many :choices
		belongs_to :field_setting

	end
end