require 'rails_helper'

RSpec.describe Priority, type: :model do
  describe 'Validations' do
    it 'should presence name' do
      should validate_presence_of :name
    end
    it 'should presence level' do
      should validate_presence_of :level
    end
  end
end
