module Binda
	class Radio < Select
		
		has_one :choice, as: :selectable

	end
end