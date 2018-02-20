FactoryBot.define do

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
  end

end
