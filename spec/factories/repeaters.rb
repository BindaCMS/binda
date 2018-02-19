FactoryBot.define do

	sequence(:repeater_name){ |n| "##{n} Repeater" }

	# Article repeater
  factory :repeater, class: Binda::Repeater do
		association :field_setting, factory: :selection_setting
  end

end
