FactoryBot.define do
  factory :priority do
    name { Faker::Lorem.words }
    level { Faker::Number.unique.number(digits: 4) }
  end
end
