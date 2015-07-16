module Search
  module Domain
    class GoogleRestaurantRepository
      def initialize(restaurant_search)
        @search = restaurant_search
      end

      def find_places(cuisine, occasion, location, radius)
        @search.find_places(cuisine, occasion, location, radius)
      end
    end
  end
end