require 'rails_helper'

RSpec.describe PlacesController, type: [:controller] do

=begin
  describe 'GET search' do
    it 'should return 7' do
      get :search, :format => :json

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
=end
end
