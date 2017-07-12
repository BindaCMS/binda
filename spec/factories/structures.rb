FactoryGirl.define do

  sequence(:article_structure_title) { |n| "N.#{n} Article" }

  # Structure
  factory :structure, class: Binda::Structure do 
		sequence(:name) { |n| "##{n} structure" }
		slug { "#{name}".parameterize }
	end

	# Article structure
  factory :article_structure, parent: :structure do
  	name { generate :article_structure_title }
	end

  # Article structure with components
	# @see https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#associations
  factory :article_structure_with_components, parent: :structure do
    transient do
      components_count 5
    end
    after(:create) do |structure, evaluator|
      create_list( :article_component, evaluator.components_count, structure: structure)
    end
  end

  # Article structure with components
  # @see https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#associations
  factory :article_structure_with_components_and_fields, parent: :structure do
    transient do
      components_count 5
    end
    after(:create) do |structure, evaluator|
      create(:field_group, structure: structure)
      create_list( :article_component_with_fields, evaluator.components_count, structure: structure)
    end
  end

end