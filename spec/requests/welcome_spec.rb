require 'rails_helper'

RSpec.describe 'Welcomes', type: :request do
  describe 'GET /index' do
    it 'return 200' do
      get '/'
      expect(response).to have_http_status(:ok)
    end
  end
end
