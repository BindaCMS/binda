FactoryBot.define do
	factory :image, class: Binda::Image do
		association :field_setting, factory: :image_setting
	end
end