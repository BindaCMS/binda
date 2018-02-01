FactoryBot.define  do

	factory :selection, class: Binda::Selection do
		association :field_setting, factory: :selection_setting
	end
	
	factory :component_and_selection, class: Binda::Component, parent: :component do 
		after(:create) do |component|
			create(:selection, fieldable_id: component.id, fieldable_type: component.class.name)
		end
	end

end
