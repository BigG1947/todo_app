FactoryBot.define do
  factory :todo_list do
    title { Faker::Lorem.words }
    description { Faker::Lorem.words }
    association :user

    factory :todo_lists_full do
      transient do
        comments_count { 5 }
        tasks_count { 5 }
      end

      after(:create) do |todo_list, evaluator|
        create_list(:comment, evaluator.comments_count, {todo_list: todo_list, user: todo_list.user})
        create_list(:task, evaluator.tasks_count, todo_list: todo_list)

        todo_list.reload
      end

      factory :todo_lists_with_comments do
        transient do
          comments_count { 5 }
          comments_by_members { 5 }
        end

        after(:create) do |todo_list, evaluator|
          create_list(:confirmed_invite, 1, {todo_list: todo_list, user: create(:user)})
          create_list(:comment, evaluator.comments_count, {todo_list: todo_list, user: todo_list.user})
          create_list(:comment, evaluator.comments_by_members, {todo_list: todo_list, user: todo_list.invites.first.user})

          todo_list.reload
        end
      end

      factory :todo_lists_with_members do
        transient do
          members_count { 5 }
        end

        after(:create) do |todo_list, evaluator|
          create_list(:invite, evaluator.members_count - 2, {todo_list: todo_list})
          create_list(:confirmed_invite, 1, {todo_list: todo_list})
          create_list(:unconfirmed_invite, 1, {todo_list: todo_list})

          todo_list.reload
        end
      end
    end
  end
end