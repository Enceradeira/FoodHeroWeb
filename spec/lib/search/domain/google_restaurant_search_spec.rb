require 'rails_helper'

GooglePlace = Search::Infrastructure::GooglePlace
Coordinate = Search::Domain::Coordinate

module Helper
  def google_place(place_id, latitude, longitude)
    GooglePlace.new(place_id, coordinate(latitude, longitude))
  end

  def coordinate(latitude, longitude)
    Coordinate.new(latitude, longitude)
  end
end

RSpec.configure do |c|
  c.include Helper
end

module Search::Domain
  describe 'GoogleRestaurantSearch' do
    let(:london) { coordinate(51.507571, -0.127702) }
    let(:search) { GoogleRestaurantSearch.new(radar_search) }
    let(:radius) { 10000 }
    let(:find_places) { search.find_places 'Indian food', 'lunch', london, radius }
    let(:three_google_places) { [
        google_place('A45', 51.004587, 0.2254),
        google_place('B22', 51.4456, 0.7778),
        google_place('C44', 51.2211, 0.25548)
    ] }

    describe 'find_places' do
      context 'with radar_search-double' do
        let(:radar_search) { double() }

        it 'should return places from google' do
          allow(radar_search).to receive(:find_places).and_return([google_place('A45', 51.004587, 0.2254)])

          places = find_places

          expect(places).not_to be_empty
          place = places[0]
          expect(place.placeId).to be == 'A45'
          expect(place.location).to be == coordinate(51.004587, 0.2254)
        end

        context 'when radius equal 0' do
          let(:radius) { 1 }

          it 'should calculate cuisineRelevance 1 for all places' do
            allow(radar_search).to receive(:find_places).and_return(three_google_places)
            places = find_places
            expect(places[0].cuisineRelevance).to be_within(0.01).of(1)
            expect(places[1].cuisineRelevance).to be_within(0.01).of(1)
            expect(places[2].cuisineRelevance).to be_within(0.01).of(1)
          end
        end

        context 'when radius equal half max.radius' do
          let(:radius) { Search::Domain::GoogleRestaurantSearch.google_max_search_radius / 2 }

          it 'should calculate a decreasing cuisineRelevance for more irrelevant place' do
            allow(radar_search).to receive(:find_places).and_return(three_google_places)
            places = find_places
            expect(places[0].cuisineRelevance).to be == 1
            expect(places[1].cuisineRelevance).to be == 0.75
            expect(places[2].cuisineRelevance).to be == 0.5
          end
        end

        context 'when radius equal max.radius' do
          let(:radius) { Search::Domain::GoogleRestaurantSearch.google_max_search_radius }

          it 'should calculate a decreasing cuisineRelevance for more irrelevant place' do
            allow(radar_search).to receive(:find_places).and_return(three_google_places)
            places = find_places
            expect(places[0].cuisineRelevance).to be == 1
            expect(places[1].cuisineRelevance).to be == 0.5
            expect(places[2].cuisineRelevance).to be == 0
          end
        end

        [0, Search::Domain::GoogleRestaurantSearch.google_max_search_radius/2, Search::Domain::GoogleRestaurantSearch.google_max_search_radius].each do |r|
          context "with radius #{r}" do
            it 'should calculate cuisineRelevance 1 when there is only one place' do
              allow(radar_search).to receive(:find_places).and_return([google_place('A45', 51.004587, 0.2254)])

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
                                                                       min_price: 0,
                                                                       max_price: 4})
        end
      end
    end
  end
end