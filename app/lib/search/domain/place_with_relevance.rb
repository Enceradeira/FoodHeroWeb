module Search
  module Domain
    class PlaceWithRelevance < Struct.new(:placeId,:location,:cuisineRelevance)
    end
  end
end
