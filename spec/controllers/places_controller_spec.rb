require 'rails_helper'

RSpec.describe PlacesController, type: [:controller,:api] do

  describe 'GET search' do
    it 'should return 7' do
      get :search, :format => :json

      bla = ActiveSupport::JSON.encode([7])
      unbla = JSON.parse(bla)

      expect(response).to be_success
      expect(json).to eq([7])
    end
  end
end
