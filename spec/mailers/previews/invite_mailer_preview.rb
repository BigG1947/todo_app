# Preview all emails at http://localhost:3000/rails/mailers/invite_mailer
class InviteMailerPreview < ActionMailer::Preview
  def invite_email
    invite = Invite.new(user: User.last, todo_list: TodoList.first)
    invite.id = 1
    invite.invite_token = 'test_token_for_invite'
    InviteMailer.with(invite: invite).invite_email
  end
end
