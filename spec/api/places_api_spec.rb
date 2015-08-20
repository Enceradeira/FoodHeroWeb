require 'rails_helper'

describe 'Places API', :type=>[:request] do

  describe 'GET search' do
    it 'should return places from Google-places-API' do
      get '/api/v1/places?cuisine=&occasion=lunch&location=40.732457, -73.998907'

      expect(response).to have_http_status(:success)
      expect(json).not_to be_empty
      first_place = json[0]
      expect(first_place['placeId']).not_to be_empty
      expect(first_place['location']).not_to be_nil
      expect(first_place['location']['latitude']).not_to be == 0
      expect(first_place['location']['longitude']).not_to be == 0
      expect(first_place['cuisineRelevance']).to be > 0

      price_levels = json.map{|s| s['priceLevel']}.uniq
      expect(price_levels.length).to be > 2 # some priceLevels should have been found
    end
  end
end