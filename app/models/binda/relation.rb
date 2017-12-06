module Binda
  # Relation 
  # 
  # This model is used to connect components and boards to each others.
  # 
  # `Relation` gathers all connection a `Component` record has with other records (being 
  #   another `Component` or `Board`). It's possible to have multiple relations for the 
  #   same component and each one can gather connections to several other components.
  #   Any relation has one owner and several dependents. A relation is a one-direction operation
  #   meaning that an owner can choose its dependents, not the other way around.
  #   
  # Reference: https://www.railstutorial.org/book/following_users
  # 
  # @example: owner = Binda::Component.first
  #   dependent = Binda::Component.last
  #   relation_setting = Binda::FieldSetting.create(field_type: relation, field_group_id: owner.structure.field_groups.first)
  #   relation = owner.relations.where(field_setting_id: relation_setting.id).first
  #   relation.dependent_components << dependent
  class Relation < ApplicationRecord

    belongs_to :fieldable, polymorphic: true
    belongs_to :field_setting

    # Relations are the connection between a Owner to its Dependents
    # The Active Relation connects a Relation to a Dependent (which is can be a Component or a Board)
    # The Passive Relation connects a Relation to a Owner (which is can be a Component or a Board)
    has_many :active_relations, class_name: "RelationLink", 
                                dependent: :destroy, 
                                as: :dependent
    has_many :passive_relations, class_name: "RelationLink", 
                                 dependent: :destroy, 
                                 as: :owner


    # Dependents are connected to a owner in a Passive Relation
    # Strictly speaking you cannot choose an Owner for a Dependent,
    # you can do just the opposite: choose a Dependent starting from a Owner
    # 
    # The current version support components and boards separately
    has_many :dependent_components, through: :passive_relations, 
                                    source: :dependent, 
                                    source_type: "Binda::Component"
                                    
    # Owner are connected to its Dependents in a Active Relation
    # meaning its possible to connect a Owner to as many Dependents
    # as it's needed.
    # 
    # The current version support components and boards separately
    has_many :owner_components, through: :active_relations, 
                                source: :owner, 
                                source_type: "Binda::Component"

    # Owner are connected to its Dependents in a Active Relation
    # meaning its possible to connect a Owner to as many Dependents
    # as it's needed.
    # 
    # The current version support components and boards separately
    has_many :dependent_boards, through: :passive_relations, 
                                source: :dependent, 
                                source_type: "Binda::Board"

    has_many :owner_boards, through: :active_relations, 
                            source: :owner, 
                            source_type: "Binda::Board"


    # Owner are connected to its Dependents in a Active Relation
    # meaning its possible to connect a Owner to as many Dependents
    # as it's needed.
    # 
    # The current version support components and boards separately
    has_many :dependent_repeaters, through: :passive_relations, 
                                source: :dependent, 
                                source_type: "Binda::Repeater"

    has_many :owner_repeaters, through: :active_relations, 
                            source: :owner, 
                            source_type: "Binda::Repeater"

    # Makes sure that the group of related components doesn't include the component that owns the group
    # in other words makes sure that the component doesn't relate to itself
    validates_each :owner_component_ids do |model, attr, value| 
        if model.fieldable_type == 'Binda::Component' && value.include?(model.fieldable_id)
            model.errors.add(attr, "#{FieldSetting.find(model.field_setting_id).name.capitalize} contains a reference to the current #{model.fieldable_type.constantize.find(model.fieldable_id).structure.name.capitalize}")
        end
    end

  end
end
