FactoryGirl.define do
  factory :user, class: Binda::User do
  	pw = FFaker::Internet.password
    email { FFaker::Internet.email }
    password { pw }
    password_confirmation { pw }
  end
end