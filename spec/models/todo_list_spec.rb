require 'rails_helper'

RSpec.describe TodoList, type: :model do

  subject { create(:todo_lists_full) }
  describe 'Validations' do
    it 'should presence :title' do
      should validate_presence_of :title
    end
  end

  describe 'Associations' do
    it 'belong to user' do
      should belong_to :user
    end
    it 'have many tasks' do
      should have_many(:tasks).dependent(:delete_all)
    end
    it 'have many invites' do
      should have_many(:invites).dependent(:delete_all)
    end
    it 'have many members' do
      should have_many(:members).through(:invites)
    end
    it 'have many comments' do
      should have_many(:comments).dependent(:delete_all)
    end
  end
end
