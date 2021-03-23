class Invite < ApplicationRecord
  belongs_to :user
  belongs_to :todo_list

  validates :todo_list_id, :user_id, presence: true
  validate :it_is_todo_list_owner

  has_secure_token :invite_token, length: 36

  private

  def it_is_todo_list_owner
    errors.add(:user, 'This user is todo list owner') if user.todo_lists.exists? id: todo_list.id
  end
end
