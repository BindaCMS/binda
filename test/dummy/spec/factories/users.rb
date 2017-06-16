FactoryGirl.define do
  factory :user, class: Binda::User do
  	pw = 'abcDEF123$£@'
    email "admin@binda.com"
    password pw
    password_confirmation pw
  end
end