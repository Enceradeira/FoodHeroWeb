require 'rails_helper'

GooglePlace = Search::Infrastructure::GooglePlace

module Search::Domain
  describe GoogleRestaurantSearch do
    let(:london) { build(:coordinate) }
    let(:search) { GoogleRestaurantSearch.new(radar_search) }
    let(:radius) { 10000 }
    let(:min_price) { 1 }
    let(:max_price) { 3 }
    let(:find_places) { search.find_places 'Indian food', 'lunch', london, radius, min_price, max_price }
    let(:three_google_places) { [build(:google_place), build(:google_place), build(:google_place)] }

    describe 'find_places' do
      context 'with radar_search-double' do
        let(:radar_search) { double() }


        it 'should return places from google' do
          location = build(:coordinate, latitude: 51.004587, longitude: 0.2254)
          google_place = build(:google_place, placeId: 'A45', location: location)
          allow(radar_search).to receive(:find_places).and_return([google_place])

          places = find_places

          expect(places).not_to be_empty
          place = places[0]
          expect(place.placeId).to be == 'A45'
          expect(place.location).to be == build(:coordinate, latitude: 51.004587, longitude: 0.2254)
        end

        context 'when radius equal 0' do
          let(:radius) { 0 }

          it 'should calculate cuisineRelevance 1 for all places' do
            allow(radar_search).to receive(:find_places).and_return(three_google_places)
            places = find_places
            expect(places[0].cuisineRelevance).to be_within(0.01).of(1)
            expect(places[1].cuisineRelevance).to be_within(0.01).of(1)
            expect(places[2].cuisineRelevance).to be_within(0.01).of(1)
          end
        end

        context 'when radius equal half max.radius' do
          let(:radius) { GoogleRestaurantSearch.google_max_search_radius / 2 }

          it 'should calculate a decreasing cuisineRelevance for more irrelevant place' do
            allow(radar_search).to receive(:find_places).and_return(three_google_places)
            places = find_places
            expect(places[0].cuisineRelevance).to be == 1
            expect(places[1].cuisineRelevance).to be == 0.75
            expect(places[2].cuisineRelevance).to be == 0.5
          end
        end

        context 'when radius equal max.radius' do
          let(:radius) { GoogleRestaurantSearch.google_max_search_radius }

          it 'should calculate a decreasing cuisineRelevance for more irrelevant place' do
            allow(radar_search).to receive(:find_places).and_return(three_google_places)
            places = find_places
            expect(places[0].cuisineRelevance).to be == 1
            expect(places[1].cuisineRelevance).to be == 0.5
            expect(places[2].cuisineRelevance).to be == 0
          end
        end

        [0, GoogleRestaurantSearch.google_max_search_radius/2, GoogleRestaurantSearch.google_max_search_radius].each do |r|
          context "with radius #{r}" do
            it 'should calculate cuisineRelevance 1 when there is only one place' do
              allow(radar_search).to receive(:find_places).and_return([build(:google_place)])

              places = find_places
              expect(places[0].cuisineRelevance).to be == 1
            end
          end
        end
      end

      context 'with radar_search-spy' do
        let(:radar_search) { spy() }

        it 'should use correct parameters' do
          allow(radar_search).to receive(:find_places).and_return([])
          find_places
          expect(radar_search).to have_received(:find_places).with({
                                                                       cuisine: 'Indian food',
                                                                       types: OccasionToGoogleTypeMapper.type_for_lunch,
                                                                       coordinate: london,
                                                                       radius: radius,
                                                                       min_price: min_price,
                                                                       max_price: max_price})
        end
      end
    end
  end
end