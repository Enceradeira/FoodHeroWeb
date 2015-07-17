module Search
  module Domain
    class Place < Struct.new(:placeId, :location, :cuisineRelevance, :priceLevel)
    end
  end
end
