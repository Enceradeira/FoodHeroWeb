module Search
  module Domain
    class GoogleRestaurantSearch
      def initialize(google_radar_search)
        @search = google_radar_search
      end

      def find_places(cuisine, occasion, coordinate, radius)
        types = []

        @search.find_places(cuisine: cuisine, types: types, coordinate: coordinate, radius: radius, min_price: 0, max_price: 4).map do |place|
          Place.new(place.placeId, place.location, 0.89)
        end
      end
    end
  end
end


