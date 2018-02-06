FactoryBot.define do

	factory :image, class: Binda::Image do
		association :field_setting, factory: :image_setting
	end

	factory :component_and_image, class: Binda::Component, parent: :component do
		after(:create) do |component|
			create(:image, fieldable_id: component.id, fieldable_type: component.class.name)
		end
	end

end