require 'rails_helper'

describe 'Places API', :type=>[:request] do

  describe 'GET search' do
    it 'should return places from Google-places-API' do
      get '/api/v1/places?cuisine=Indian%20Food&occasion=lunch&location=51.500152,-0.126236'

      expect(response).to have_http_status(:success)
      expect(json).not_to be_empty
      first_place = json[0]
      expect(first_place['placeId']).not_to be_empty
      expect(first_place['location']).not_to be_nil
      expect(first_place['location']['latitude']).not_to be_empty
      expect(first_place['location']['longitude']).not_to be_empty
      expect(first_place['cuisineRelevance']).to be > 0
    end
  end
end