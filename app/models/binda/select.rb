module Binda
	class Select < ApplicationRecord

		has_and_belongs_to_many :choices

	end
end