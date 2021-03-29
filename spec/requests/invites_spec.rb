require 'rails_helper'

RSpec.describe 'Invites', type: :request do
  let!(:todo_list) { create(:todo_lists_with_members) }
  let(:user) { todo_list.user }
  let(:confirmed_member) { todo_list.invites.where(confirm: true).first.user }
  let(:unconfirmed_member) { todo_list.invites.where(confirm: false).first.user }
  let(:another_user) { create(:user) }
  let(:another_invite) { create(:unconfirmed_invite) }
  before(:each) { sign_in user }

  describe 'GET /todo_lists/:todo_list_id/invites #INDEX' do
    it 'should have access as owner' do
      get todo_list_invites_path todo_list_id: todo_list.id
      expect(response).to render_template :index
    end
    it 'should have not access as member' do
      sign_in confirmed_member
      get todo_list_invites_path todo_list_id: todo_list.id
      expect(assigns(:todo_list)).to be_nil
      expect(response).to redirect_to todo_lists_path
    end
    it 'should have not access as another user' do
      sign_in another_user
      get todo_list_invites_path todo_list_id: todo_list.id
      expect(assigns(:todo_list)).to be_nil
      expect(response).to redirect_to todo_lists_path
    end
  end

  describe 'POST /todo_lists/:todo_list_id/invites #CREATE' do
    let(:valid_params) { {invite: {email: another_user.email}} }
    let(:invalid_params_owner) { {invite: {email: todo_list.user.email}} }
    let(:invalid_params_member) { {invite: {email: todo_list.members.first.email}} }

    it 'should create invite to another user' do
      expect do
        post todo_list_invites_path todo_list_id: todo_list.id, params: valid_params
      end.to change(Invite, :count).by(1)
      expect(assigns(:invite)).to be_valid
      expect(response).to redirect_to todo_list_path todo_list
    end

    it 'should not create invite to todo list owner' do
      expect do
        post todo_list_invites_path todo_list_id: todo_list.id, params: invalid_params_owner
      end.to_not change(Invite, :count)
      expect(assigns(:invite)).to_not be_valid
      expect(response).to redirect_to todo_list_path todo_list
    end

    it 'should not create invite to todo list member' do
      expect do
        post todo_list_invites_path todo_list_id: todo_list.id, params: invalid_params_member
      end.to_not change(Invite, :count)
      expect(assigns(:invite)).to_not be_valid
      expect(response).to redirect_to todo_list_path todo_list
    end
  end

  describe 'GET /invites/:id/confirm #CONFIRM' do
    it 'should confirm invite' do
      sign_in another_invite.user
      get confirm_invite_path id: another_invite.invite_token
      expect { another_invite.reload }.to change(another_invite, :confirm).from(false).to(true)
      expect(response).to redirect_to todo_list_path another_invite.todo_list
    end
    it 'should not confirm stranger invite' do
      sign_in another_user
      get confirm_invite_path id: another_invite.invite_token
      expect { another_invite.reload }.to_not change(another_invite, :confirm)
      expect(response).to redirect_to todo_list_path another_invite.todo_list
    end
  end

  describe 'DELETE /invites/:id #DESTROY' do
    it 'should owner destroy invite ' do
      expect do
        delete invite_path id: todo_list.invites.first
      end.to change(Invite, :count).by(-1)
      expect(response).to redirect_to todo_list_invites_path todo_list
    end

    it 'should member not destroy invite' do
      sign_in confirmed_member
      expect do
        delete invite_path id: todo_list.invites.first
      end.to_not change(Invite, :count)
      expect(response).to redirect_to todo_lists_path
    end

    it 'should another user not destroy invite' do
      sign_in another_user
      expect do
        delete invite_path id: todo_list.invites.first
      end.to_not change(Invite, :count)
      expect(response).to redirect_to todo_lists_path
    end
  end
end
