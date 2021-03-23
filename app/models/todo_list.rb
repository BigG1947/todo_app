class TodoList < ApplicationRecord
  has_many :tasks

  validates :title, presence: true
end
