class TodoList < ApplicationRecord
  has_many :tasks, dependent: :delete_all
  has_many :invites, dependent: :delete_all
  has_many :members, through: :invites, source: :user
  has_many :comments, dependent: :delete_all
  belongs_to :user

  validates :title, presence: true
end
