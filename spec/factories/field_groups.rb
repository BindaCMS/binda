FactoryGirl.define do


	factory :field_group_with_fields, class: Binda::FieldGroup do
		sequence(:name) { |n| "Default details ##{n}" }
		slug { "#{name}".parameterize }
		
		after(:create) do |field_group|
			create :string_setting, field_group: field_group
			create :text_setting, field_group: field_group
			create :repeater_setting_with_fields, field_group: field_group
		end
	end

end