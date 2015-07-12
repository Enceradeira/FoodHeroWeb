require 'rails_helper'

describe 'Places API', :type=>[:request] do

  describe 'GET search' do
    it 'should return places from Google-places-API' do
      get '/api/v1/places'

      expect(response).to have_http_status(:success)
      expect(json).to eq([7])
    end
  end
end