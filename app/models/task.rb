class Task < ApplicationRecord
  belongs_to :todo_list
  belongs_to :priority

  validates :title, :deadline, :priority_id, presence: true
end
