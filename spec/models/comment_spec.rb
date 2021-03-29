require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'Validations' do
    it 'should presence text' do
      should validate_presence_of :text
    end
    it 'should presence user_id' do
      should validate_presence_of :user_id
    end
    it 'should presence todo_list_id' do
      should validate_presence_of :todo_list_id
    end
  end

  describe 'Associations' do
    it 'should belong to user' do
      should belong_to :user
    end
    it 'should belong to todo list' do
      should belong_to :todo_list
    end
  end
end
