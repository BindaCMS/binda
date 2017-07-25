module Binda
	class Select < ApplicationRecord

		has_many :choices, as: :selectable

	end
end