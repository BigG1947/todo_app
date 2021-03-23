class TasksController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.todo_lists.find(params[:todo_list_id]).tasks.create(task_params)
    redirect_to todo_list_path params[:todo_list_id]
  end

  def edit
    @task = Task.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @task.owner?(current_user)
  end

  def update
    @task = Task.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @task.owner?(current_user)

    @task.update(task_params)
    redirect_to @task.todo_list
  end

  def destroy
    @task = Task.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @task.owner?(current_user)

    @task.destroy
    redirect_to @task.todo_list
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :deadline, :priority_id)
  end
end
