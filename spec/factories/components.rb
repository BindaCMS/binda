FactoryGirl.define do

  sequence(:article_title) { |n| "This is article number #{ n }" }

  # Component
  factory :component, class: Binda::Component do
    sequence(:name) { |n| "##{n} component" }
    sequence(:position) { |n| n }
    slug { "#{name}".parameterize }
    association :structure
  end

  # Article Component
  factory :article_component, parent: :component do
		name { generate(:article_title) }
  end

  # Article Component with repeaters
  # WARNING: This should be called directly, instead use :article_structure_with_components_and_fields factory
  # @see https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#associations
  factory :article_component_with_fields, parent: :article_component do
    transient do
      _count 3
    end
    after(:create) do |article_component, evaluator|
      # fetch the deafult field group
      field_group = article_component.structure.field_groups.first
      # fetch field settings belonging to that field group 
      # (they have been created before in :article_structure_with_components_and_fields factory)
      string_setting = field_group.field_settings.find{ |fs| fs.field_type == 'string' }
      repeater_setting = field_group.field_settings.find{ |fs| fs.field_type == 'repeater' }
      # create some data
      create_list( :repeater_with_fields, evaluator._count, fieldable: article_component, field_setting: repeater_setting )
      create_list( :string, evaluator._count, fieldable: article_component, field_setting: string_setting )
    end
  end

end