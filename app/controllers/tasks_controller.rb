class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :user_is_todo_list_owner?, only: %i[edit update destroy]

  def create
    task = current_user.todo_lists.find(params[:todo_list_id]).tasks.create(task_params)
    if task.invalid?
      flash[:alert] = task.errors.full_messages.join(' | ')
    else
      flash[:notice] = 'Task has been successful created!'
    end
    redirect_to todo_list_path params[:todo_list_id]
  end

  def edit; end

  def update
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
    @task.destroy
    flash[:notice] = 'Task has been successful destroyed!'
    redirect_to @task.todo_list
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :deadline, :priority_id)
  end

  def user_is_todo_list_owner?
    @task = Task.find(params[:id])
    if current_user != @task.todo_list.user
      flash[:alert] = 'You have not access for this task'
      redirect_to todo_lists_path
    end
  end
end
