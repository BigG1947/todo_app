class TodoList < ApplicationRecord
  has_many :tasks
  has_many :invites
  has_many :members, through: :invites, source: :user
  has_many :comments
  belongs_to :user

  validates :title, presence: true
end
