FactoryBot.define  do

	factory :radio, class: Binda::Radio do
		association :field_setting, factory: :radio_setting
	end

	factory :component_and_radio, class: Binda::Component, parent: :component do 
		after(:create) do |component|
			create(:radio, fieldable_id: component.id, fieldable_type: component.class.name)
		end
	end

end
