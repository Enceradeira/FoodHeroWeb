module Search
  module Domain
    class GoogleRestaurantSearch
      class << self
        def google_max_search_radius
          50000
        end
        def google_max_search_results
          200
        end
      end

      def initialize(google_radar_search)
        @search = google_radar_search
      end

      def find_places(cuisine, occasion, coordinate, radius)
        types = OccasionToGoogleTypeMapper.map(occasion)
        places = @search.find_places(cuisine: cuisine, types: types, coordinate: coordinate, radius: radius, min_price: 0, max_price: 4)

=begin Following calculations assigns a relevance. The first places in the result-sets are more relevant.
     Furthermore it accounts for the fact that when using a greater radius results seem to become less
     specific therefore less relevant.

     minRelevance = radius * n + 1
     0            = radius * n + 1 ¦ radius == GOOGLE_MAX_SEARCH_RADIUS
     n            = -1 / GOOGLE_MAX_SEARCH_RADIUS
     minRelevance = (radius * -1 / GOOGLE_MAX_SEARCH_RADIUS) + 1
=end
        min_relevance = (-radius.to_f / self.class.google_max_search_radius) + 1
        if places.length > 1
          n = (min_relevance-1) / (places.length-1) # for most irrelevant place (last one)
        else
          n = 0
        end


=begin
    Following we calculate a linear function that assign relevance 1 to the first
    and relevance minRelevance to the last element

    relevance(place) = n*index(place) + 1
    n = (relevance(place) - 1) / index(place)
=end


        places.each_with_index.map do |place, i|
          Place.new(place.placeId, place.location, (n*i)+1)
        end
      end
    end
  end
end


