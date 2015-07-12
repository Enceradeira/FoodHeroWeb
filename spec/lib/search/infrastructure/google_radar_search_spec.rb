require 'rails_helper'

module Search::Infrastructure
  describe 'GoogleRadarSearch'  do
    let(:search){GoogleRadarSearch.new}

    describe 'find_places' do
      it 'should return something from google' do
        london = Search::Domain::Coordinate.new(51.507571, -0.127702)

        places = search.find_places 'Indian food', 'lunch', london, 10000

        expect(places).not_to be_empty
        place = places[0]

        expect(place.placeId).not_to be_empty
        expect(place.location).not_to be_nil
        expect(place.location.latitude).not_to be ==0
        expect(place.location.longitude).not_to be ==0

      end
    end
  end
end