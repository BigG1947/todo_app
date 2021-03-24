# frozen_string_literal: true
class TodoListsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_have_access?, only: :show

  def index
    @todo_lists = current_user.todo_lists
    @confirmed_invites = current_user.invites.where(confirm: true)
  end

  def show
    @todo_list = TodoList.find(params[:id])
  end

  def create
    TodoList.create(todo_list_params_with_user)
    redirect_to todo_lists_path
  end

  def edit
    @todo_list = current_user.todo_lists.find(params[:id])
  end

  def update
    current_user.todo_lists.find(params[:id]).update(todo_list_params)
    redirect_to todo_lists_path
  end

  def destroy
    current_user.todo_lists.find(params[:id]).destroy
    redirect_to todo_lists_path
  end


  private

  def todo_list_params
    params.require(:todo_list).permit(:title, :description)
  end

  def todo_list_params_with_user
    todo_list_params.merge(user: current_user)
  end

  def user_have_access?
    todo_list = TodoList.find(params[:id])
    unless todo_list.user == current_user ||
        (todo_list.members.exists?(current_user.id) && todo_list.invites.find_by_user_id(current_user.id).confirm)
      render plain: 'You have not access to this todo list', status: 403
    end
  end
end
