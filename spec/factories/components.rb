FactoryGirl.define do

  sequence(:article_title) { |n| "This is article number #{ n }" }

  # Component
  factory :component, class: Binda::Component do
    sequence(:name) { |n| "##{n} component" }
    slug { "#{name}".parameterize }
    association :structure
  end

  # Article Component
  factory :article_component, parent: :component do
		name { generate(:article_title) }
    association :structure, factory: :article_structure
  end

  # Article Component with repeaters
  # @see https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#associations
  factory :article_component_with_repeaters, parent: :article_component do
    # posts_count is declared as a transient attribute and available in
    # attributes on the factory, as well as the callback via the evaluator
    transient do
      article_components_count 5
    end

    # the after(:create) yields two values; the user instance itself and the
    # evaluator, which stores all values from the factory, including transient
    # attributes; `create_list`'s second argument is the number of records
    # to create and we make sure the user is associated properly to the post
    after(:create) do |article_component, evaluator|
      create_list( :article_repeater, evaluator.article_components_count, component: article_component)
    end
  end


end