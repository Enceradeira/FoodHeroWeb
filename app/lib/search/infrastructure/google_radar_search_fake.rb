module Search
  module Infrastructure
    class GoogleRadarSearchFake
      def find_places(cuisine:, types:, coordinate:, radius:, min_price:, max_price:)
        GoogleRadarSearch.find_places_in_fake_file(min_price, max_price)
      end
    end
  end
end

