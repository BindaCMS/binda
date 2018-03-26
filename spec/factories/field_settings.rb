FactoryBot.define do
	
	sequence(:field_name){ |n| "##{n} Field Setting" }

	factory :field_setting, class: Binda::FieldSetting do
		name { generate :field_name }
		slug { "#{name}".parameterize }
		association :field_group
	end

	factory :repeater_setting, parent: :field_setting do
		field_type 'repeater'
	end

	factory :repeater_setting_with_children_settings, parent: :repeater_setting do
		after(:create) do |repeater|
			repeater.children.create(
				name: attributes_for(:field_setting)[:name], 
				field_type: 'string', 
				field_group: repeater.field_group
			)
			repeater.children.create(
				name: attributes_for(:field_setting)[:name], 
				field_type: 'text', 
				field_group: repeater.field_group
			)
		end
	end

	factory :string_setting, parent: :field_setting do
		field_type 'string'
  end

	factory :text_setting, parent: :field_setting do
		field_type 'text'
	end

	factory :radio_setting, parent: :field_setting do
		field_type 'radio'
		allow_null false
	end

	factory :radio_setting_with_choices, parent: :radio_setting do
    transient do
      _count 3
    end
		after(:create) do |radio_setting, evaluator|
      create_list(:choice, evaluator._count, field_setting: radio_setting)
		end
	end

	factory :selection_setting, parent: :field_setting do
		field_type 'selection'
		allow_null true
	end

	factory :selection_setting_with_choices, parent: :selection_setting do
    transient do
      _count 3
    end
		after(:create) do |selection_setting, evaluator|
      create_list(:choice, evaluator._count, field_setting: selection_setting)
		end
	end

	factory :checkbox_setting, parent: :field_setting do
		field_type 'checkbox'
		allow_null true
	end

	factory :checkbox_setting_with_choices, parent: :checkbox_setting do
    transient do
      _count 3
    end
		after(:create) do |checkbox_setting, evaluator|
      create_list(:choice, evaluator._count, field_setting: checkbox_setting)
		end
	end


	factory :relation_setting, parent: :field_setting do
		field_type 'relation'
	end

	factory :image_setting, parent: :field_setting do
		field_type 'image'
	end

	factory :video_setting, parent: :field_setting do
		field_type 'video'
	end

	factory :audio_setting, parent: :field_setting do
		field_type 'audio'
	end

	factory :svg_setting, parent: :field_setting do 
		field_type 'svg'
	end
	
end
