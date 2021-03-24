class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_have_access?, only: %i[index create]
  before_action :user_owner?, only: :destroy

  COMMENTS_PER_PAGE = 10

  def index
    @todo_list = TodoList.find(params[:todo_list_id])
    @page = params[:page].to_i || 1
    @page_count = (@todo_list.comments.count / COMMENTS_PER_PAGE.to_f).ceil
    @comments = @todo_list.comments
                          .order(created_at: :desc)
                          .limit(COMMENTS_PER_PAGE).offset((@page - 1) * COMMENTS_PER_PAGE)
  end

  def create
    comment = Comment.create(comments_params)
    redirect_back(fallback_location: comment.todo_list)
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to comment.todo_list
  end

  private

  def comments_params
    params.require(:comment).permit(:text).merge(user: current_user, todo_list_id: params[:todo_list_id])
  end

  def user_have_access?
    todo_list = TodoList.find(params[:todo_list_id])
    invite = todo_list.invites.find_by_user_id(current_user)
    unless todo_list.user == current_user || (invite&.confirm)
      render plain: "you have not access to this todo list", status: 403
    end
  end

  def user_owner?
    unless Comment.find(params[:id]).todo_list.user == current_user
      render plain: "you have not access to this comment", status: 403
    end
  end
end
