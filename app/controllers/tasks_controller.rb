class TasksController < ApplicationController
  before_action :authenticate_user!

  def create
    task = current_user.todo_lists.find(params[:todo_list_id]).tasks.create(task_params)
    if task.invalid?
      flash[:alert] = task.errors.full_messages.join(' | ')
    else
      flash[:notice] = 'Task has been successful created!'
    end
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
    if @task.invalid?
      flash.now[:alert] = @task.errors.full_messages.join(' | ')
      render :edit
      return
    end
    flash[:notice] = 'Task has been successful updated!'
    redirect_to @task.todo_list
  end

  def destroy
    @task = Task.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @task.owner?(current_user)

    @task.destroy
    flash[:notice] = 'Task has been successful destroyed!'
    redirect_to @task.todo_list
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :deadline, :priority_id)
  end
end
