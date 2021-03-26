class InvitesController < ApplicationController
  before_action :authenticate_user!

  def index
    @todo_list = current_user.todo_lists.find(params[:todo_list_id])
  end

  def create
    user = User.find_by_email(invite_params[:email])
    if user.nil?
      flash[:alert] = 'User not found in system'
      redirect_to todo_list_path params[:todo_list_id]
      return
    end
    todo_list = current_user.todo_lists.find(params[:todo_list_id])
    invite = Invite.create(user: user, todo_list: todo_list)
    if invite.invalid?
      flash[:alert] = invite.errors.full_messages.join(' | ')
    else
      flash[:notice] = 'invite has been send to email'
    end
    redirect_to todo_list
  end

  def confirm
    invite = Invite.find_by_invite_token(params[:id])
    invite.update(confirm: true) if current_user == invite.user
    flash[:notice] = 'Now you have access to this todo list'
    redirect_to invite.todo_list
  end

  def destroy
    invite = Invite.find(params[:id])
    raise ActiveRecord::RecordNotFound unless invite.todo_list.user == current_user

    invite.destroy
    flash['notice'] = 'Invite has been successful canceled!'
    redirect_to invite.todo_list
  end

  private

  def invite_params
    params.require(:invite).permit(:email)
  end
end
