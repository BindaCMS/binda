module Binda
  class AssociationField < ApplicationRecord

    belongs_to :associable, polymorphic: true

    # children_fieldable_relates "names" the Association join table for accessing through the children_fieldable association
    has_many :active_relationships, class_name: "Relationship", dependent: :destroy, as: :children_fieldable
    # parent_fieldable_relates "names" the Association join table for accessing through the parent_fieldable association
    has_many :passive_relationships, class_name: "Relationship", dependent: :destroy, as: :parent_fieldable

=begin
    # source: :children_fieldable matches with the belong_to :children_fieldable identification in the Association model
    has_many :children_fieldables, class_name: "Component", through: :passive_relationships, source: :children_fieldable, source_type: "Binda::Component"
    # source: :parent_fieldable matches with the belong_to :children_fieldable identification in the Association model
    has_many :parent_fieldables, class_name: "Component", through: :active_relationships, source: :parent_fieldable, source_type: "Binda::Component"
=end

    # source: :children_fieldable matches with the belong_to :children_fieldable identification in the Association model
    has_many :children_fieldables_component, through: :passive_relationships, source: :children_fieldable, source_type: "Binda::Component"
    # source: :parent_fieldable matches with the belong_to :children_fieldable identification in the Association model
    has_many :parent_fieldables_component, through: :active_relationships, source: :parent_fieldable, source_type: "Binda::Component"


    # source: :children_fieldable matches with the belong_to :children_fieldable identification in the Association model
    has_many :children_fieldables_board, through: :passive_relationships, source: :children_fieldable, source_type: "Binda::Structure"
    # source: :parent_fieldable matches with the belong_to :children_fieldable identification in the Association model
    has_many :parent_fieldables_board, through: :active_relationships, source: :parent_fieldable, source_type: "Binda::Structure"
=begin
    # source: :children_fieldable matches with the belong_to :children_fieldable identification in the Association model
    has_many :children_fieldables, class_name: "Board", through: :passive_relationships, source: :children_fieldable, source_type: "Binda::Board"
    # source: :parent_fieldable matches with the belong_to :children_fieldable identification in the Association model
    has_many :parent_fieldables, class_name: "Board", through: :active_relationships, source: :parent_fieldable, source_type: "Binda::Board"
=end


=begin
    validates :parent_fieldable_id, presence: true
    validates :children_fieldable_id, presence: true
=end

    validates :name, presence: true
    validates :slug, presence: true

  end
end
