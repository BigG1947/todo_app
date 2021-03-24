class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :todo_list

  validates :text, :user_id, :todo_list_id, presence: true
end
