FactoryGirl.define do

	factory :field_group, class: Binda::FieldGroup do
		name "Default details"
		slug { "#{name}".parameterize }
		
		after(:create) do |field_group|
			create :repeater_setting, field_group: field_group
			create :string_setting, field_group: field_group
		end
	end

end