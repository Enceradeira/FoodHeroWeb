module Search
  module Domain
    class GoogleRestaurantRepository
      def initialize(restaurant_search)
        @search = restaurant_search
      end

      def find_places(cuisine, occasion, location)
        optimal_radius = 0
        price_range = (GoogleRestaurantSearch.google_price_level_min..GoogleRestaurantSearch.google_price_level_max)
        results_all_prices = RadiusCalculator.do_until_nr_of_results_ok do |radius|
          optimal_radius = radius
          @search.find_places(cuisine, occasion, location, radius, price_range.first, price_range.last)
        end

        places_per_level = price_range.map do |price_level|
          @search.find_places(cuisine, occasion, location, optimal_radius, price_level, price_level).map do |place|
            [place.placeId, price_level]
          end
        end.flatten(1).to_h

        results_all_prices.map do |place|
          place_id = place.placeId
          unless places_per_level.has_key?(place_id)
            raise StandardError, "place '#{place_id}' not found in places_per_level"
          end
          Place.new(place_id, place.location, place.cuisineRelevance, places_per_level[place_id])
        end
      end
    end
  end
end