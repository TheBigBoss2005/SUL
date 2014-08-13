# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment do
    price 1234
    status false
  end
end
