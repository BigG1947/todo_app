class TodoListsController < ApplicationController
  before_action :authenticate_user!

  def index
    @todo_lists = current_user.todo_lists
  end

  def show
    @todo_list = current_user.todo_lists.find(params[:id])
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
end
