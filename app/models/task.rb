class Task < ApplicationRecord
  belongs_to :todo_list
  belongs_to :priority

  validates :title, :deadline, presence: true

  def owner?(user)
    todo_list.user == user
  end
end
