FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password }

    factory :user_with_todo_lists do
      transient do
        todo_list_count { 5 }
      end

      todo_lists do
        Array.new(todo_list_count) { association(:todo_list) }
      end

      after(:create) do |user, evaluator|
        create_list(:confirmed_invite, evaluator.todo_list_count, user: user)

        user.reload
      end
    end
  end
end
