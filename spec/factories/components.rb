FactoryGirl.define do

  sequence :article_structure_title do |n|
    "N.#{n} Article"
  end

	sequence :article_title do |n|
	 	"This is article number #{ n }"
	end

	factory :article_component, class: Binda::Component do
		name { generate :article_title }
    slug { "#{name}".parameterize }
	 	association :structure, factory: :article_structure
	end

  factory :article_structure, class: Binda::Structure do
  	name { generate :article_structure_title }
    slug { "#{name}".parameterize }
    
		# https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#associations
    factory :article_structure_with_article_components do
      # posts_count is declared as a transient attribute and available in
      # attributes on the factory, as well as the callback via the evaluator
      transient do
        article_components_count 5
      end

      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the post
      after(:create) do |article_structure, evaluator|
        create_list( :article_component, evaluator.article_components_count, structure: article_structure)
      end
    end
	end

end