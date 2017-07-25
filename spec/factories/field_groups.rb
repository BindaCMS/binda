FactoryGirl.define do

	factory :field_group, class: Binda::FieldGroup do
		sequence(:name) { |n| "Default details ##{n}" }
		slug { "#{name}".parameterize }
		association :structure
	end
	
	factory :field_group_with_fields, parent: :field_group do
		after(:create) do |field_group|
			create :string_setting, field_group: field_group
			create :text_setting, field_group: field_group
			create :repeater_setting_with_fields, field_group: field_group
			create :radio_setting_with_choices, field_group: field_group
			create :select_setting_with_choices, field_group: field_group
		end
	end

end