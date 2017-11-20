module Binda
	class Relationship < ApplicationRecord

		belongs_to :parent_fieldable, polymorphic: true, class_name: "Component"
		belongs_to :children_fieldable, polymorphic: true, class_name: "Component"
		validates :parent_fieldable_id, presence: true
		validates :children_fieldable_id, presence: true

	end
end
