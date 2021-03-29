require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let!(:todo_list) { create :todo_lists_with_comments }
  let(:user) { todo_list.user }
  let(:member) { todo_list.members.first }
  let(:another_user) { create :user }
  before(:each) { sign_in user }

  describe 'GET /todo_lists/:todo_list_id/comments #INDEX' do
    it 'should not access to another user' do
      sign_in another_user
      get todo_list_comments_path todo_list_id: todo_list.id
      expect(response).to redirect_to todo_lists_path
    end

    it 'should have access as owner' do
      get todo_list_comments_path todo_list_id: todo_list.id
      expect(assigns(:comments)).to eq todo_list.comments.order(created_at: :desc).limit(CommentsController::COMMENTS_PER_PAGE)
      expect(response).to render_template :index
    end

    it 'should have access as member' do
      sign_in member
      get todo_list_comments_path todo_list_id: todo_list.id
      expect(assigns(:comments)).to eq todo_list.comments.order(created_at: :desc).limit(CommentsController::COMMENTS_PER_PAGE)
      expect(response).to render_template :index
    end
  end

  describe 'POST /todo_lists/:todo_list_id/comments #CREATE' do
    let(:valid_params) { {comment: {text: 'text comment'}} }
    let(:invalid_params) { {comment: {text: ''}} }

    it 'should not access to another user' do
      sign_in another_user
      post todo_list_comments_path todo_list_id: todo_list.id, params: valid_params
      expect(response).to redirect_to todo_lists_path
    end

    it 'should create comment with valid params as todo owner' do
      expect do
        post todo_list_comments_path todo_list_id: todo_list.id, params: valid_params
      end.to change(Comment, :count).by 1
      expect(assigns(:comment)).to be_valid
      expect(response).to redirect_to todo_list_path id: todo_list.id
    end

    it 'should create comment with valid params as todo member' do
      sign_in member
      expect do
        post todo_list_comments_path todo_list_id: todo_list.id, params: valid_params
      end.to change(Comment, :count).by 1
      expect(assigns(:comment)).to be_valid
      expect(response).to redirect_to todo_list_path id: todo_list.id
    end

    it 'should not create comment with invalid params' do
      expect do
        post todo_list_comments_path todo_list_id: todo_list.id, params: invalid_params
      end.to_not change(Comment, :count)
      expect(assigns(:comment)).to_not be_valid
      expect(response).to redirect_to todo_list_path id: todo_list.id
    end
  end

  describe 'DELETE /comments/:id #DESTROY' do
    it 'should destroy as todo list owner' do
      expect do
        delete comment_path id: todo_list.comments.first.id
      end.to change(Comment, :count).by(-1)
      expect(assigns(:comment)).to_not be_nil
      expect(assigns(:comment).destroyed?).to be_truthy
      expect(response).to redirect_to todo_list
    end

    it 'should not destroy as todo list member' do
      sign_in member
      expect do
        delete comment_path id: todo_list.comments.first.id
      end.to_not change(Comment, :count)
      expect(assigns(:comment).destroyed?).to be_falsey
      expect(response).to redirect_to todo_list_path todo_list
    end

    it 'should not destroy as another user' do
      sign_in another_user
      expect do
        delete comment_path id: todo_list.comments.first.id
      end.to_not change(Comment, :count)
      expect(assigns(:comment).destroyed?).to be_falsey
      expect(response).to redirect_to todo_list_path todo_list
    end
  end
end
