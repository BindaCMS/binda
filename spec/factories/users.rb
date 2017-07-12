FactoryGirl.define do
  
  factory :user, class: Binda::User do

    email "mail@domain.com"
  	
  	pw = "abcDEF123$£@"
    password pw
    password_confirmation pw
  
  end

end