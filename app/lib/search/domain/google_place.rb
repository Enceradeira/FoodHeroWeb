module Search
  module Domain
    class GooglePlace < Struct.new(:placeId,:location,:cuisineRelevance)
    end
  end
end
