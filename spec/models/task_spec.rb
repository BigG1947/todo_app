require 'rails_helper'

RSpec.describe Task, type: :model do

  subject { create(:task) }

  describe 'Validations' do
    it 'should presence :title' do
      should validate_presence_of :title
    end
    it 'should presence :deadline' do
      should validate_presence_of :deadline
    end
    it 'should presence :priority' do
      should validate_presence_of :priority_id
    end
  end

  describe 'Associations' do
    it 'should belong to priority' do
      should belong_to :priority
    end
    it 'should belong to todo list' do
      should belong_to :todo_list
    end
  end
end
