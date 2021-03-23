class Task < ApplicationRecord
  belongs_to :todo_list
  belongs_to :priority

  validates :title, :deadline, presence: true
end
