module Search
  module Domain
    class RadiusCalculator
      class << self
        private
        def another_search_required(result, delta, radius)
          length = result.length
          max_nr_results = Search::Domain::GoogleRestaurantSearch.google_max_search_results

          length_nok = length >= max_nr_results || length < (max_nr_results * 0.5)
          makes_sense_to_change_radius = delta > min_radius_change
          length_nok && makes_sense_to_change_radius && radius <= Search::Domain::GoogleRestaurantSearch.google_max_search_radius
        end

        public
        def initial_search_radius
          Search::Domain::GoogleRestaurantSearch.google_max_search_radius/2
        end

        def initial_radius_change
          Search::Domain::GoogleRestaurantSearch.google_max_search_radius/4
        end

        def min_radius_change
          250
        end

        def do_until_nr_of_results_ok
          radius = initial_search_radius
          radius_delta = initial_radius_change
          result = []
          # 'binary' search starting from the initial_search_radius
          while true
            result = yield radius
            if result.length >= Search::Domain::GoogleRestaurantSearch.google_max_search_results
              radius -= radius_delta
              break unless another_search_required(result, radius_delta, radius)
            else
              radius += radius_delta
              break unless another_search_required(result, radius_delta, radius)
            end
            radius_delta /= 2
          end
          result
        end
      end
    end
  end
end
