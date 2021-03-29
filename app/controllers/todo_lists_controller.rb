# frozen_string_literal: true
class TodoListsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_have_access?, only: :show

  def index
    @todo_lists = current_user.todo_lists
    @confirmed_invites = current_user.invites.where(confirm: true)
  end

  def show; end

  def create
    todo_list = TodoList.create(todo_list_params_with_user)
    if todo_list.invalid?
      flash[:alert] = todo_list.errors.full_messages.join(' | ')
    else
      flash[:notice] = 'Todo list has been successful created!'
    end
    redirect_to todo_lists_path
  end

  def edit
    @todo_list = current_user.todo_lists.find_by(id: params[:id])
    if @todo_list.nil?
      flash[:alert] = 'Todo list is not found'
      redirect_to todo_lists_path
    end
  end

  def update
    @todo_list = current_user.todo_lists.find_by(id: params[:id])
    if @todo_list.nil?
      flash[:alert] = 'Todo list is not found'
      return redirect_to todo_lists_path
    end
    @todo_list.update(todo_list_params)
    if @todo_list.invalid?
      flash.now[:alert] = @todo_list.errors.full_messages.join(' | ')
      return render :edit
    end
    flash[:notice] = 'Todo list has been successful updated!'
    redirect_to todo_lists_path
  end

  def destroy
    @todo_list = current_user.todo_lists.find_by(id: params[:id])
    if @todo_list.nil?
      flash[:alert] = 'Todo List is not found'
      return redirect_to todo_lists_path
    end
    @todo_list.destroy
    flash[:notice] = 'Todo list has been successful destroyed!'
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
    @todo_list = TodoList.find(params[:id])
    unless @todo_list.user == current_user ||
        (@todo_list.members.exists?(current_user.id) && @todo_list.invites.find_by_user_id(current_user.id).confirm)
      flash[:alert] = 'You have not access to this todo list'
      redirect_to todo_lists_path
    end
  end
end
