module Binda
	class Relationship < ApplicationRecord

		belongs_to :owner, polymorphic: true
		belongs_to :dependent, polymorphic: true

		validates :owner_id, presence: true
		validates :dependent_id, presence: true

	end
end
