class TodoListsController < ApplicationController
  def index
    @todo_lists = TodoList.all
  end

  def show
    @todo_list = TodoList.find(params[:id])
  end

  def create
    TodoList.create(todo_list_params)
    redirect_to todo_lists_path
  end

  def edit
    @todo_list = TodoList.find(params[:id])
  end

  def update
    TodoList.find(params[:id]).update(todo_list_params)
    redirect_to todo_lists_path
  end

  def destroy
    TodoList.find(params[:id]).destroy
    redirect_to todo_lists_path
  end


  private

  def todo_list_params
    params.require(:todo_list).permit(:title, :description)
  end
end
