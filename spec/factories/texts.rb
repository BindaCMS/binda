FactoryGirl.define do
	
	sequence(:text_name){ |n| "##{n} Lorem ipsum sit dolor" }

	factory :string, class: Binda::Text do
		content { generate :text_name }
	end

	factory :text, class: Binda::Text do
		content { generate :text_name }
	end

end