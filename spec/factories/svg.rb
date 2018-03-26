FactoryBot.define do

	factory :svg, class: Binda::Svg do
		association :field_setting, factory: :svg_setting
	end

	factory :component_and_svg, class: Binda::Component, parent: :component do
		after(:create) do |component|
			create(:svg, fieldable_id: component.id, fieldable_type: component.class.name)
		end
	end

end