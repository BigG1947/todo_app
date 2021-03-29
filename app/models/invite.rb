class Invite < ApplicationRecord
  belongs_to :user
  belongs_to :todo_list

  validates :todo_list_id, :user_id, presence: true
  validates :user_id, uniqueness: {scope: :todo_list_id, message: 'this user already have invite for this todo list'}
  validate :it_is_todo_list_owner, if: :todo_list_id

  has_secure_token :invite_token, length: 36

  after_create :send_invite_email

  private

  def it_is_todo_list_owner
    errors.add(:user, 'This user is todo list owner') if user&.todo_lists&.exists? id: todo_list.id
  end

  def send_invite_email
    InviteMailer.with(invite: self).invite_email.deliver_now
  end
end
