FactoryBot.define do
	
	factory :choice, class: Binda::Choice do
		sequence(:label){ |n| "Choice ##{n}" }
		sequence(:value){ |n| "Lorem ipsum #{n}" }
		association :field_setting, factory: :selection_setting
	end

end
