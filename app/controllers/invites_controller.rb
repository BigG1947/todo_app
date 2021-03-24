class InvitesController < ApplicationController
  before_action :authenticate_user!

  def index
    @todo_list = current_user.todo_lists.find(params[:todo_list_id])
  end

  def create
    # rescue User not found error and TodoList not found error
    user = User.find_by_email!(invite_params[:email]) || render
    todo_list = current_user.todo_lists.find(params[:todo_list_id])
    Invite.create(user: user, todo_list: todo_list)
    redirect_to todo_list
  end

  def confirm
    invite = Invite.find_by_invite_token(params[:id])
    invite.update(confirm: true) if current_user == invite.user
    redirect_to invite.todo_list
  end

  def destroy
    invite = Invite.find(params[:id])
    raise ActiveRecord::RecordNotFound unless invite.todo_list.user == current_user

    invite.destroy
    redirect_to invite.todo_list
  end

  private

  def invite_params
    params.require(:invite).permit(:email)
  end
end
