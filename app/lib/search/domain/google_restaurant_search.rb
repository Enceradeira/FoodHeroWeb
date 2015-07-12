module Search
  module Domain
    class GoogleRestaurantSearch
      def find_places cuisine, occasion, coordinate

         coordinate = Coordinate.new('51.500152','-0.126236')
         google_place_new = GooglePlace.new('999987-2', coordinate, 0.998)
         [google_place_new]
      end
    end
  end
end


