FactoryBot.define  do

	factory :checkbox, class: Binda::Checkbox do
		association :field_setting, factory: :checkbox_setting
	end

	factory :component_and_checkbox, class: Binda::Component, parent: :component do 
		after(:create) do |component|
			create(:checkbox, fieldable_id: component.id, fieldable_type: component.class.name)
		end
	end

end