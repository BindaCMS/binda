module Binda
	class Relationship < ApplicationRecord

		belongs_to :parent_fieldable, polymorphic: true
		belongs_to :children_fieldable, polymorphic: true


		validates :parent_fieldable_id, presence: true
		validates :children_fieldable_id, presence: true

	end
end
