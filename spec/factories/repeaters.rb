FactoryBot.define do

	sequence(:repeater_name){ |n| "##{n} Repeater" }

	# Article repeater
  factory :repeater, class: Binda::Repeater do
  end

end
