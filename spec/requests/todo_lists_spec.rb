require 'rails_helper'

RSpec.describe TodoListsController, type: :request do
  describe 'GET /todo_lists #INDEX' do
    before(:each) { get '/todo_lists' }
    context 'user is not authenticate' do
      it 'should be redirect to sign in' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'user is authenticate' do
      let(:user) { create :user_with_todo_lists, todo_list_count: 5 }
      before(:each) { sign_in user }

      it 'should be status ok' do
        get '/todo_lists'
        expect(response).to have_http_status(:ok)
      end

      it 'should assign @todo_list' do
        get '/todo_lists'
        expect(assigns(:todo_lists)).to eq(user.todo_lists)
      end

      it 'should assign @confirmed_invites' do
        get '/todo_lists'
        expect(assigns(:confirmed_invites)).to eq(user.invites.where(confirm: true))
      end
    end
  end

  describe 'GET /todo_list/:id #SHOW' do
    let(:user) { create :user_with_todo_lists, todo_list_count: 1 }
    before(:each) { sign_in user }
    let(:todo_list) { user.todo_lists.first }
    let(:other_todo_list) { create(:todo_list) }

    it 'user is not authenticate' do
      sign_out user
      get todo_list_url(id: todo_list.id)
      expect(response).to redirect_to new_user_session_url
    end

    it 'should assigns todo list and status ok' do
      get todo_list_url(id: todo_list.id)
      expect(assigns(:todo_list)).to eq todo_list
      expect(response).to have_http_status(:ok)
    end

    it 'it is not user todo list' do
      get todo_list_url(id: other_todo_list.id)
      expect(response).to redirect_to todo_lists_path
    end

    it 'should assign available todo list and status ok' do
      get todo_list_url(id: user.invites.first.todo_list.id)
      expect(assigns(:todo_list)).to eq user.invites.first.todo_list
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /todo_lists #CREATE' do
    let(:valid_params) { {title: 'new todo_list', description: 'test desc'} }
    before(:each) { post '/todo_lists', params: {todo_list: valid_params} }

    context 'user is authenticate' do
      let(:user) { create :user }
      before(:each) { sign_in user }

      it 'should be create new todo_list' do
        expect do
          post '/todo_lists', params: {:todo_list => valid_params}
        end.to change(TodoList, :count).by(1)
      end

      it 'should railse error without params' do
        expect do
          post '/todo_lists', params: {}
        end.to raise_error ActionController::ParameterMissing
      end

      it 'should be not create with invalid params' do
        expect do
          post '/todo_lists', params: {todo_list: {title: ''}}
        end.to_not change(TodoList, :count)
        expect(response).to redirect_to todo_lists_path
      end
    end
  end

  describe 'GET /todo_list/:id/edit #EDIT' do
    let(:user) { create(:user_with_todo_lists, todo_list_count: 1) }
    let(:todo_list) { user.todo_lists.first }
    let(:other_todo_list) { create(:todo_list) }
    before(:each) { sign_in user }

    it 'should be todo_list owner' do
      get edit_todo_list_path(id: todo_list.id)
      expect(response).to have_http_status(:ok)
      expect(assigns(:todo_list)).to eq(todo_list)
    end

    it 'should redirect to if user is not owner' do
      get edit_todo_list_path(id: other_todo_list.id)
      expect(response).to redirect_to todo_lists_path
      expect(assigns(:todo_list)).to be_nil
    end
  end

  describe 'PUT /todo_list/:id #UPDATE' do
    let(:user) { create(:user_with_todo_lists) }
    let(:todo_list) { user.todo_lists.first }
    let(:other_todo_list) { create(:todo_list) }
    let(:valid_params) { {todo_list: {title: 'valid title', description: 'valid description'}} }
    let(:invalid_params) { {todo_list: {title: '', description: 'valid description'}} }
    before(:each) { sign_in user }

    it 'should be update with valid params' do
      put todo_list_path(id: todo_list.id), params: valid_params
      expect(assigns(:todo_list).title).to eq valid_params[:todo_list][:title]
      expect(assigns(:todo_list).description).to eq valid_params[:todo_list][:description]
    end

    it 'should railse error without params' do
      expect { put todo_list_path(id: todo_list.id), params: {} }.to raise_error ActionController::ParameterMissing
    end

    it 'should be render edit view if not valid params' do
      put todo_list_path(todo_list.id), params: invalid_params
      expect(assigns(:todo_list)).to_not be_valid
      expect(response).to render_template :edit
    end

    it 'should redirect to if user is not owner' do
      put todo_list_path(id: other_todo_list.id), params: valid_params
      expect(response).to redirect_to todo_lists_path
      expect(assigns(:todo_list)).to be_nil
    end
  end

  describe 'DELETE /todo_list/:id #DESTROY' do
    let(:user) { create :user_with_todo_lists, todo_list_count: 1 }
    let(:todo_list) { user.todo_lists.first }
    let(:other_todo_list) { create :todo_list }
    before(:each) { sign_in user }

    it 'should be destroy todo list' do
      expect { delete todo_list_path(id: todo_list.id) }.to change(TodoList, :count).by(-1)
      expect(response).to redirect_to todo_lists_path
    end

    it 'should redirect to if user is not owner' do
      delete todo_list_path(id: other_todo_list.id)
      expect(response).to redirect_to todo_lists_path
      expect(assigns(:todo_list)).to be_nil
    end
  end
end
