class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_have_access?, only: %i[index create]
  before_action :user_owner?, only: :destroy

  COMMENTS_PER_PAGE = 10

  def index
    @page = (params[:page] || 1).to_i
    @page_count = (@todo_list.comments.size / COMMENTS_PER_PAGE.to_f).ceil
    @comments = @todo_list.comments
                    .order(created_at: :desc)
                    .limit(COMMENTS_PER_PAGE).offset((@page - 1) * COMMENTS_PER_PAGE)
  end

  def create
    @comment = Comment.create(comments_params)
    if @comment.invalid?
      flash[:alert] = @comment.errors.full_messages.join(' | ')
    else
      flash[:notice] = 'Comment has been successful created!'
    end
    redirect_back(fallback_location: @todo_list)
  end

  def destroy
    @comment.destroy
    flash[:notice] = 'Comment has been successful destroyed!'
    redirect_to @comment.todo_list
  end

  private

  def comments_params
    params.require(:comment).permit(:text).merge(user: current_user, todo_list_id: params[:todo_list_id])
  end

  def user_have_access?
    @todo_list = TodoList.find(params[:todo_list_id])
    invite = @todo_list.invites.find_by_user_id(current_user)
    unless @todo_list.user == current_user || (invite&.confirm)
      flash[:alert] = 'you have not access to this todo list'
      redirect_to todo_lists_path
    end
  end

  def user_owner?
    @comment = Comment.find(params[:id])
    unless @comment.todo_list.user == current_user
      flash[:alert] = 'you have not access to this comment'
      redirect_to @comment.todo_list
    end
  end
end
