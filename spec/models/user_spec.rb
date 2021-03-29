require 'rails_helper'

RSpec.describe User, type: :model do

  subject { build(:user) }

  describe 'Validations' do
    it 'should presence :name' do
      should validate_presence_of :name
    end
    it 'should presence :email' do
      should validate_presence_of :email
    end
  end

  describe 'Associations' do
    it 'should has_many todo_lists' do
      should have_many :todo_lists
    end
    it 'should has_many todo_lists' do
      should have_many :invites
    end
    it 'should has_many todo_lists through invites' do
      should have_many(:available_todo).through(:invites)
    end
  end
end
