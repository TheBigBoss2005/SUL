# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    password 'hogehoge'
    sequence(:email) { |n| "hoge#{n}@example.com" }
    sequence(:name) { |n| "user_#{n}" }
    sequence(:login_id) { |n| "user_#{n}" }
  end
end
