module Search
  module Infrastructure
    class GoogleRadarSearch
      API_URL = 'https://maps.googleapis.com/maps/api/place/'
      GOOGLE_API_KEY = 'AIzaSyDL2sUACGU8SipwKgj-mG-cl3Sik1qJGjg'

      class << self
        def write_body_to_fake_file(min_price, max_price, body)
          File.open(file_name_for_fake_file(min_price, max_price), 'w') { |file| file.write(body) }
        end

        def file_name_for_fake_file(min_price, max_price)
          File.join(File.dirname(__FILE__), "google-price-#{min_price}to#{max_price}.json")
        end

        def proc_body_or_yield_error(body)
          json = JSON.parse(body)

          status = json['status']
          unless status == 'OK' || status == 'ZERO_RESULTS'
            yield if block_given?
            return []
          end

          json['results'].map do |result|
            location = result['geometry']['location']
            coordinate = Domain::Coordinate.new(location['lat'], location['lng'])
            Search::Infrastructure::GooglePlace.new(result['place_id'], coordinate)
          end
        end

        def default_connection
          @default_connection ||= Faraday.new(url: API_URL, params: {key: GOOGLE_API_KEY}, ssl: {verify: false}) do |faraday|
            faraday.adapter Faraday.default_adapter
            #faraday.response :logger, ::Logger.new(STDOUT), bodies: false
          end
        end

        def find_places_in_fake_file(min_price, max_price)
          file_name = GoogleRadarSearch.file_name_for_fake_file(min_price,max_price)
          body = File.read(file_name)
          GoogleRadarSearch.proc_body_or_yield_error(body)
        end
      end

      def initialize(connection)
        @connection = connection
      end

      def find_places(cuisine:, types:, coordinate:, radius:, min_price:, max_price:)

        types_as_string = types.join('|')

        response = @connection.get 'radarsearch/json',
                                   {
                                       keyword: cuisine,
                                       location: "#{coordinate.latitude},#{coordinate.longitude}",
                                       radius: radius,
                                       minprice: min_price,
                                       maxprice: max_price,
                                       types: types_as_string,
                                       opennow: 1
                                   }
        unless response.success?
          raise_error(response)
        end

        #self.class.write_body_to_fake_file(min_price,max_price,response.body)

        self.class.proc_body_or_yield_error(response.body) {raise_error(response)}
      end


      private def raise_error(response)
        raise StandardError, "request to #{API_URL} failed.\nStatus: #{response.status}\nBody: #{response.body}"
      end
    end
  end
end

