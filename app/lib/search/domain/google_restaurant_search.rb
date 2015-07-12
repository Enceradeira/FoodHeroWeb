module Search
  module Domain
    class GoogleRestaurantSearch
      def find_places(cuisine, occasion, coordinate, radius)
        Search::Infrastructure::GoogleRadarSearch.new.find_places(cuisine,occasion,coordinate,radius).map do |place|
          Place.new(place.placeId,place.location,0.89)
        end
      end
    end
  end
end


