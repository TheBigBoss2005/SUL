# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    sequence(:name) { |n| "event_#{n}" }
    sequence(:memo) { |n| "event_memo_#{n}" }
    date '2014/01/01'
  end
end
