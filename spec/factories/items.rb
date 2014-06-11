# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    sequence(:memo) { |n| "item_memo_#{n}" }
    price 12_345
  end
end
