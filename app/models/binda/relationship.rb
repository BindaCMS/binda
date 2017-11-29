module Binda
	class Relationship < ApplicationRecord

		belongs_to :parent_related, polymorphic: true
=begin
		belongs_to :children_related, polymorphic: true
=end


		validates :parent_related_id, presence: true
=begin
		validates :children_related_id, presence: true
=end

	end
end
