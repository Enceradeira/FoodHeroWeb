require 'rails_helper'

module Search::Infrastructure
  describe GoogleRadarSearch do
    let(:search) { GoogleRadarSearch.new(stub_connection) }
    let(:stub_connection) {
      Faraday.new do |builder|
        builder.adapter :test do |stub|
          'no stubbed request for get  '
          stub.get(expected_url) { |_| [response_code, {}, response_body] }
        end
      end
    }

    describe 'find_places' do
      let(:location) { Search::Domain::Coordinate.new(51.507571, -0.127702) }
      let(:radius) { 10000 }
      let(:cuisine) { 'Indian food' }
      let(:types) { %w(restaurant meal_takeaway) }
      let(:min_price) { 1 }
      let(:max_price) { 4 }
      let(:expected_url) { '/radarsearch/json?keyword=Indian+food&location=51.507571,-0.127702&radius=10000&minprice=1&maxprice=4&types=restaurant%7Cmeal_takeaway&opennow=1' }

      let(:find_places) { lambda { search.find_places cuisine: cuisine, types: types, coordinate: location, radius: radius, min_price: min_price, max_price: max_price } }
      let(:response_code) { 200 }
      let(:response_body) { '' }

      context 'when response is 400' do
        let(:response_code) { 400 }
        let(:response_body) { 'internal error' }

        it 'should return exception' do
          expect(find_places).to raise_error(StandardError, 'request to https://maps.googleapis.com/maps/api/place/ failed.
Status: 400
Body: internal error')
        end
      end

      context 'when response is empty' do
        let(:response_body) { '{"html_attributions":[],"results":[],"status":"ZERO_RESULTS"}' }

        it 'should return nothing' do
          expect(find_places.call).to be_empty
        end
      end

      context 'when response is not empty' do
        let(:response_body) { File.read(File.join(File.dirname(__FILE__), '/google_radar_search_json_example.json')) }

        it 'should return places' do
          places = find_places.call
          expect(places.length).to be == 4

          place = places[0]
          expect(place.placeId).to be == 'ChIJyWEHuEmuEmsRm9hTkapTCrk'
          location = place.location
          expect(location).not_to be_nil
          expect(location.latitude).to be == -33.870775
          expect(location.longitude).to be == 151.199025
        end
      end
    end

    describe 'find_places_in_fake_file' do
      let(:price_range) { (Search::Domain::GoogleRestaurantSearch.google_price_level_min..Search::Domain::GoogleRestaurantSearch.google_price_level_max) }

      it 'should return something for every priceLevel' do
        all_places = GoogleRadarSearch.find_places_in_fake_file(price_range.first, price_range.max)
        expect(all_places).not_to be_empty

        all_places_per_price_level = price_range.map do |price|
          GoogleRadarSearch.find_places_in_fake_file(price, price)
        end.flatten

        expect(all_places_per_price_level).to include(*all_places)
      end
    end
  end
end