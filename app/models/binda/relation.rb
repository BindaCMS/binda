module Binda
	class Relation < ApplicationRecord

		belongs_to :children_fieldable, foreign_key: "children_fieldable_id", class_name: "Component", polymorphic: true
		belongs_to :parent_fieldable, foreign_key: "parent_fieldable_id", class_name: "Component", polymorphic: true

	end
end
