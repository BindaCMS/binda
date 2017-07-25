FactoryGirl.define  do
	
	factory :select, class: Binda::Select do
		association :field_setting, factory: :select_setting
	end

end
