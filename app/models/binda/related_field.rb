module Binda
  # Related Field 
  # 
  # This model is used to connect components and boards to each others.
  # 
  # The gotcha here is that a `RelatedField` gathers all association a `Component`
  #   record has with other records. At the moment we are just using the parent relationship for which 
  #   a component can be connected to components via a parent relationship (it has many parent related components).
  #   Another version, not applied to the current administration panel is the children relationship, which connect 
  #   components in a has-many-children-related components. This was created to avoid confusion when connecting components
  #   in multiple directions, for example: component A is connected to its parent component B, while component B 
  #   is connected to its parent component C; doing `component.related_fields.parent_related_components` we should get 
  #   only component C, while `component.related_fields` should return both A and C. 
  class RelatedField < ApplicationRecord

    belongs_to :fieldable, polymorphic: true

    # children_fieldable_relates "names" the Association join table for accessing through the children_fieldable association
    has_many :active_relationships, class_name: "Relationship", dependent: :destroy, as: :children_related
    # parent_fieldable_relates "names" the Association join table for accessing through the parent_fieldable association
    has_many :passive_relationships, class_name: "Relationship", dependent: :destroy, as: :parent_related


    # source: :children_fieldable matches with the belong_to :children_fieldable identification in the Association model
    has_many :children_related_components, through: :passive_relationships, source: :children_related, source_type: "Binda::Component"
    # source: :parent_fieldable matches with the belong_to :children_fieldable identification in the Association model
    has_many :parent_related_components, through: :active_relationships, source: :parent_related, source_type: "Binda::Component"


    # source: :children_fieldable matches with the belong_to :children_fieldable identification in the Association model
    has_many :children_related_boards, through: :passive_relationships, source: :children_related, source_type: "Binda::Board"
    # source: :parent_fieldable matches with the belong_to :children_fieldable identification in the Association model
    has_many :parent_related_boards, through: :active_relationships, source: :parent_related, source_type: "Binda::Board"

    # Makes sure that the group of related components doesn't include the component that owns the group
    # in other words makes sure that the component doesn't relate to itself
    validates_each :parent_related_component_ids do |model, attr, value| 
        if model.fieldable_type == 'Binda::Component' && value.include?(model.fieldable_id)
            model.errors.add(attr, "#{FieldSetting.find(model.field_setting_id).name.capitalize} contains a reference to the current #{model.fieldable_type.constantize.find(model.fieldable_id).structure.name.capitalize}")
        end
    end

  end
end
