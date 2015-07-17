require 'rails_helper'

module Search::Domain
  class GoogleRestaurantSearchFake
    def initialize(places_and_level)
      @places_per_price_level = places_and_level
    end

    def find_places(cuisine, occasion, location, radius, min_price_level, max_price_level)
      result = @places_per_price_level.select do |k, v|
        k >= min_price_level && k <= max_price_level
      end.map do |k, v|
        v
      end.flatten
      result
    end
  end

  describe GoogleRestaurantRepository do

    describe 'find_places' do
      let(:search_result_nok) { (1..GoogleRestaurantSearch.google_max_search_results).map { |_| build(:place_with_relevance) } }
      let(:search_result_ok) { (1..GoogleRestaurantSearch.google_max_search_results/2).map { |_| build(:place_with_relevance) } }
      let(:price_range) { (GoogleRestaurantSearch.google_price_level_min..GoogleRestaurantSearch.google_price_level_max) }

      let(:repository) { GoogleRestaurantRepository.new(restaurant_search) }
      let(:coordinate) { build(:coordinate) }

      context 'with restaurant_search-spy' do
        let(:restaurant_search) { spy() }

        it 'should call RestaurantSearch with correct cuisine, occassion and coordinate' do
          allow(restaurant_search).to receive(:find_places).and_return(search_result_ok)

          repository.find_places('Indian', 'lunch', coordinate)

          initial_radius = RadiusCalculator.initial_search_radius
          expect(restaurant_search).to have_received(:find_places).with('Indian', 'lunch', coordinate, initial_radius,
                                                                        price_range.first, price_range.last)
        end

        it 'should change search radius when result are not specific enough' do
          allow(restaurant_search).to receive(:find_places).and_return(search_result_nok, search_result_ok)

          repository.find_places('Indian', 'lunch', coordinate)

          initial_radius = RadiusCalculator.initial_search_radius
          initial_decrease = RadiusCalculator.initial_radius_decrease
          expect(restaurant_search).to have_received(:find_places).with('Indian', 'lunch', coordinate,
                                                                        initial_radius, price_range.first, price_range.last)
          expect(restaurant_search).to have_received(:find_places).with('Indian', 'lunch', coordinate,
                                                                        initial_radius - initial_decrease, price_range.first, price_range.last)
        end
      end

      context 'with restaurant_search-fake' do
        let(:restaurant_search) { GoogleRestaurantSearchFake.new(places_per_price_level) }
        let(:places_per_price_level) {
          price_range.map do |level|
            [level, [build(:place_with_relevance)]]
          end.to_h
        }

        it 'should assign price_level to places' do
          result = repository.find_places('Indian', 'lunch', coordinate)

          price_range.each do |price_level|
            place_for_level = result.select { |p| p.priceLevel == price_level }.first
            expected_place = places_per_price_level[price_level].first
            expected_place_as_place = Place.new(
                expected_place.placeId, expected_place.location, expected_place.cuisineRelevance, price_level)

            expect(place_for_level).to be == expected_place_as_place
          end
        end
      end
    end
  end
end