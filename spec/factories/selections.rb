FactoryGirl.define  do
	
	factory :selection, class: Binda::Selection do
		association :field_setting, factory: :selection_setting
	end

end
