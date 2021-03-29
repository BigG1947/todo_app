FactoryBot.define do
  factory :invite do
    association :user
    association :todo_list
    confirm { Faker::Boolean.boolean }

    factory :confirmed_invite do
      confirm { true }
    end

    factory :unconfirmed_invite do
      confirm { false }
    end
  end
end
