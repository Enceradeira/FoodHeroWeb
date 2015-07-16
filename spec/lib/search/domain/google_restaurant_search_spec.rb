require 'rails_helper'

module Search::Domain
  describe 'GoogleRestaurantSearch' do
    let(:london) { Search::Domain::Coordinate.new(51.507571, -0.127702) }
    let(:search) { Search::Domain::GoogleRestaurantSearch.new(radar_search) }

    describe 'find_places' do
      context 'with radar_search-double' do
        let(:radar_search) { double() }

        it 'should return places from google' do
          place_location = Search::Domain::Coordinate.new(51.004587, 0.2254)
          allow(radar_search).to receive(:find_places).and_return([Search::Infrastructure::GooglePlace.new('A45', place_location)])

          places = search.find_places 'Indian food', 'lunch', london, 10000

          expect(places).not_to be_empty
          place = places[0]
          expect(place.placeId).to be == 'A45'
          expect(place.location).to be == place_location
        end

        it 'should calculate relevance of place'
      end

      context 'with radar_search-spy' do
        let(:radar_search) { spy() }

        it 'should use correct parameters' do

          search.find_places 'Indian food', 'lunch', london, 10000
          expect(radar_search).to have_received(:find_places).with({
                                                                       cuisine: 'Indian food',
                                                                       types: OccasionToGoogleTypeMapper.type_for_lunch,
                                                                       coordinate: london,
                                                                       radius: 10000,
                                                                       min_price: 0,
                                                                       max_price: 4})
        end
      end
    end
  end
end