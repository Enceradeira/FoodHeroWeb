require 'rails_helper'

RSpec.describe PlacesController, type: [:controller] do

  describe 'GET search' do
    it 'should return 7' do
      get :search, :format => :json

      expect(response).to have_http_status(:success)
      expect(json).to eq([7])
    end
  end
end
