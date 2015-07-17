module Search
  module Domain
    class GoogleRestaurantRepository
      def initialize(restaurant_search)
        @search = restaurant_search
      end

      def find_places(cuisine, occasion, location)
        @search.find_places(cuisine, occasion, location, RadiusCalculator.initial_search_radius)
      end
    end
  end
end