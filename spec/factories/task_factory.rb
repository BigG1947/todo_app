FactoryBot.define do
  factory :task do
    title { Faker::Lorem.words }
    description { Faker::Lorem.words }
    deadline { Faker::Date.between(from: Date.today, to: Date.today + 7) }
    association :todo_list
    association :priority
  end
end
