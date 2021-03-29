require 'rails_helper'

RSpec.describe TasksController, type: :request do
  describe 'GET /tasks/:id/edit #EDIT' do
    let(:todo_list) { create(:todo_lists_full, comments_count: 5, tasks_count: 1) }
    let(:user) { todo_list.user }
    let(:another_user) { create(:user) }
    before(:each) { sign_in user }

    it 'should redirect to to sign in' do
      sign_out user
      get todo_list_path(id: todo_list.id)
      expect(response).to redirect_to new_user_session_path
    end

    it 'should be assign tasks' do
      get edit_task_path(id: todo_list.tasks.first.id)
      expect(response).to render_template :edit
    end

    it 'should be redirect to /todo_lists' do
      sign_in another_user
      get edit_task_path(id: todo_list.tasks.first.id)
      expect(response).to redirect_to todo_lists_path
    end
  end

  describe 'POST /todo_lists/:todo_list_id/tasks #CREATE' do
    let(:todo_list) { create :todo_list }
    let(:user) { todo_list.user }
    let(:another_user) { create :user }
    before(:each) { sign_in user }
    let(:valid_params) { {task: {title: 'test_task', description: 'test_task', deadline: Date.tomorrow, priority_id: Priority.create(name: 'test', level: 1).id}} }
    let(:invalid_params) { {task: {title: ''}} }


    it 'should create task with valid params' do
      expect do
        post todo_list_tasks_path(todo_list_id: todo_list.id), params: valid_params
      end.to change(Task, :count).by 1
      expect(assigns(:task)).to be_valid
      expect(response).to redirect_to todo_list_path todo_list.id
    end

    it 'should not create task with invalid params' do
      expect do
        post todo_list_tasks_path(todo_list_id: todo_list.id), params: invalid_params
      end.to_not change(Task, :count)
      expect(assigns(:task)).to_not be_valid
      expect(response).to redirect_to todo_list_path todo_list.id
    end

    it 'should redirect with not owner todo list' do
      sign_in another_user
      post todo_list_tasks_path(todo_list.id), params: valid_params
      expect(response).to redirect_to todo_lists_path
    end
  end

  describe 'GET /task/:id #UPDATE' do
    let(:todo_list) { create :todo_lists_full }
    let(:user) { todo_list.user }
    let(:another_user) { create :user }
    before(:each) { sign_in user }
    let(:valid_params) { {task: {title: 'test_task', description: 'test_task', deadline: Date.tomorrow, priority_id: Priority.create(name: 'test', level: 1).id}} }
    let(:invalid_params) { {task: {title: ''}} }

    it 'should update task with valid params' do
      put task_path(id: todo_list.tasks.first.id), params: valid_params
      updated_task = assigns(:task)
      expect(updated_task).to be_valid
      expect(updated_task.title).to eq valid_params[:task][:title]
      expect(updated_task.description).to eq valid_params[:task][:description]
      expect(updated_task.priority_id).to eq valid_params[:task][:priority_id]
      expect(updated_task.deadline).to eq valid_params[:task][:deadline]

      expect(response).to redirect_to todo_list_path todo_list.id
    end

    it 'should not update task with invalid params' do
      put task_path(id: todo_list.tasks.first.id), params: invalid_params
      expect(assigns(:task)).to_not be_valid
      expect(response).to render_template :edit
    end

    it 'should redirect with not owner todo list' do
      sign_in another_user
      put task_path(id: todo_list.tasks.first.id), params: valid_params
      expect(response).to redirect_to todo_lists_path
    end
  end

  describe 'DELETE /task/:id #DESTROY' do
    let!(:todo_list) { create :todo_lists_full }
    let(:another_todo) { create :todo_list }
    let(:user) { todo_list.user }
    before(:each) { sign_in user }
    let(:another_user) { create(:user) }

    it 'should redirect with not owner todo list' do
      sign_in another_user
      delete task_path(id: todo_list.tasks.first.id)
      expect(response).to redirect_to todo_lists_path
    end

    it 'should delete task' do
      expect { delete task_path(id: todo_list.tasks.first.id) }.to change(Task, :count).by(-1)
      expect(response).to redirect_to todo_list_path todo_list.id
    end
  end
end
