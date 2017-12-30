module Binda
	class RelationLink < ApplicationRecord

		belongs_to :owner, class_name: "Binda::Relation"
		belongs_to :dependent, polymorphic: true

		validates :owner_id, presence: true
		validates :dependent_id, presence: true

	end
end
