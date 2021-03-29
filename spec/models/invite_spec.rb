require 'rails_helper'

RSpec.describe Invite, type: :model do

  subject { create :invite }

  describe 'Validates' do
    it 'should presence user_id' do
      should validate_presence_of :user_id
    end
    it 'should presence todo_list_id' do
      should validate_presence_of :todo_list_id
    end

    context 'invited user is todo list owner' do
      let(:todo_list) { create(:todo_list) }
      let(:owner) { todo_list.user }
      subject { Invite.new(todo_list: todo_list, user: owner) }

      it 'should be not valid' do
        expect(subject).to_not be_valid
      end
    end
  end

  describe 'Associations' do
    it 'should belong to user' do
      should belong_to :user
    end
    it 'should belong to todo_list' do
      should belong_to :todo_list
    end
  end
end
