FactoryGirl.define do

	sequence(:repeater_name){ |n| "##{n} Repeater" }
  
	# Article repeater
  factory :repeater, class: Binda::Repeater do
  end

  factory :repeater_with_fields, parent: :repeater do
		after(:create) do |repeater|
			create :string, fieldable: repeater, field_setting: repeater.field_setting.children.find{ |fs| fs.field_type == "string" }
			create :text, fieldable: repeater, field_setting: repeater.field_setting.children.find{ |fs| fs.field_type == "text" }
		end
  end

end