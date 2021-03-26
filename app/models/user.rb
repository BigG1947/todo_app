class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :todo_lists
  has_many :invites
  has_many :available_todo, through: :invites, source: :todo_list

  validates :name, presence: true
end
