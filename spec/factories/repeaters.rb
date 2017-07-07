FactoryGirl.define do

	sequence(:repeater_name){ |n| "##{n} Repeater" }
  
	# Article repeater
  factory :repeater, class: Binda::Repeater do
  end

  factory :repeater_with_fields, parent: :repeater do
		after(:create) do
			create :string
		end
  end

end