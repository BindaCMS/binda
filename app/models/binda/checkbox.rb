module Binda
	class Checkbox < Select

		has_many :choices, as: :selectable

	end
end