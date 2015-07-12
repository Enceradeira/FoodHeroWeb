module Search
  module Domain
    class Place < Struct.new(:placeId,:location,:cuisineRelevance)
    end
  end
end
