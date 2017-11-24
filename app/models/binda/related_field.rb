module Binda
  class RelatedField < ApplicationRecord

    belongs_to :fieldable, polymorphic: true

    # children_fieldable_relates "names" the Association join table for accessing through the children_fieldable association
    has_many :active_relationships, class_name: "Relationship", dependent: :destroy, as: :children_related
    # parent_fieldable_relates "names" the Association join table for accessing through the parent_fieldable association
    has_many :passive_relationships, class_name: "Relationship", dependent: :destroy, as: :parent_related

=begin
    # source: :children_fieldable matches with the belong_to :children_fieldable identification in the Association model
    has_many :children_fieldables, class_name: "Component", through: :passive_relationships, source: :children_fieldable, source_type: "Binda::Component"
    # source: :parent_fieldable matches with the belong_to :children_fieldable identification in the Association model
    has_many :parent_fieldables, class_name: "Component", through: :active_relationships, source: :parent_fieldable, source_type: "Binda::Component"
=end

    # source: :children_fieldable matches with the belong_to :children_fieldable identification in the Association model
    has_many :children_related_components, through: :passive_relationships, source: :children_related, source_type: "Binda::Component"
    # source: :parent_fieldable matches with the belong_to :children_fieldable identification in the Association model
    has_many :parent_related_components, through: :active_relationships, source: :parent_related, source_type: "Binda::Component"


    # source: :children_fieldable matches with the belong_to :children_fieldable identification in the Association model
    has_many :children_related_boards, through: :passive_relationships, source: :children_related, source_type: "Binda::Board"
    # source: :parent_fieldable matches with the belong_to :children_fieldable identification in the Association model
    has_many :parent_related_boards, through: :active_relationships, source: :parent_related, source_type: "Binda::Board"

=begin
    validates :parent_fieldable_id, presence: true
    validates :children_fieldable_id, presence: true
=end

    validates :name, presence: true
    validates :slug, presence: true

  end
end
