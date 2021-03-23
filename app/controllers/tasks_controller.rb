class TasksController < ApplicationController
  def create
    p task_params
    Task.create!(task_params)
    redirect_to todo_list_path params[:todo_list_id]
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    @task.update(task_params)
    redirect_to @task.todo_list
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to @task.todo_list
  end

  private

  def task_params
    params.permit(:todo_list_id).merge(
        params.require(:task).permit(:title, :description, :deadline, :priority_id)
    )
  end
end
