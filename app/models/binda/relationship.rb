module Binda
	class Relationship < ApplicationRecord

		belongs_to :children_fieldable, foreign_key: "children_fieldable_id", class_name: "Component"
		belongs_to :parent_fieldable, foreign_key: "parent_fieldable_id", class_name: "Component"

	end
end
