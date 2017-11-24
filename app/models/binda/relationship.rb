module Binda
	class Relationship < ApplicationRecord

		belongs_to :parent_related, polymorphic: true
		belongs_to :children_related, polymorphic: true


		validates :parent_related_id, presence: true
		validates :children_related_id, presence: true

	end
end
