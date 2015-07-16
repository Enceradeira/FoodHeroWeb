module Search
  module Domain
    class GoogleRestaurantSearch
      def find_places(cuisine, occasion, coordinate, radius)
        connection = Search::Infrastructure::GoogleRadarSearch.default_connection
        search = Search::Infrastructure::GoogleRadarSearch.new(connection)

        types = []

        search.find_places(cuisine: cuisine, types: types, coordinate: coordinate, radius: radius, min_price: 0, max_price: 4).map do |place|
          Place.new(place.placeId, place.location, 0.89)
        end
      end
    end
  end
end


