FactoryGirl.define do
  
	# Article repeater
  factory :article_repeater, class: Binda::Repeater do
    name "#{ generate :article_title } gallery"
    slug { "#{name}".parameterize }
    association :component, factory: :article_component
  end

end