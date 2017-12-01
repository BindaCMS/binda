FactoryBot.define  do
	
	factory :radio, class: Binda::Radio do
		association :field_setting, factory: :radio_setting
	end

end
