FactoryGirl.define do
  factory :task do
    name "task"
    user
  end

  factory :user do
  	name "user"
  	sequence(:email) {|n| "user_#{n}@user.com" } 
  	password "abcdef123"
  	password_confirmation "abcdef123"
  end
end