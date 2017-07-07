FactoryGirl.define do
	
	sequence(:field_name){ |n| "##{n} Field Setting" }

	factory :field_setting, class: Binda::FieldSetting do
		name { generate :field_name }
		slug { "#{name}".parameterize }
	end

	factory :repeater_setting, parent: :field_setting do
		field_type 'repeater'
	end

	factory :string_setting, parent: :field_setting do
		field_type 'string'
	end

end