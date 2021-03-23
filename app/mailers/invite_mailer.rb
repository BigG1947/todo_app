class InviteMailer < ApplicationMailer
  default from: 'todo_app@example.com'

  def invite_email
    @invite = params[:invite]
    mail(to: @invite.user.email, subject: 'Invite to todo list')
  end
end

