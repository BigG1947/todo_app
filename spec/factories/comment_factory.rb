FactoryBot.define do
  factory :comment do
    text { Faker::Lorem.words }
    association :todo_list
    association :user
  end
end