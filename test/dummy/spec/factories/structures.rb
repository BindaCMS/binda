FactoryGirl.define do

  factory :structure, class: Binda::Structure do 
  	sequence :name do |n|
  		"##{n} structure"
  	end

  	factory :structure_with_slug do
  		slug { "#{name}".parameterize }
  	end

  end

end