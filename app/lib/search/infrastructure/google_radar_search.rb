module Search
  module Infrastructure
    class GoogleRadarSearch
      API_URL = 'https://maps.googleapis.com/maps/api/place/'
      GOOGLE_API_KEY = 'AIzaSyDL2sUACGU8SipwKgj-mG-cl3Sik1qJGjg'

      class << self
        def default_connection
          @default_connection ||= Faraday.new(url: API_URL, params: {key: GOOGLE_API_KEY}, ssl: {verify: false}) do |faraday|
            faraday.adapter Faraday.default_adapter
          end
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

        body = response.body
        json = JSON.parse(body)

        status = json['status']
        unless status == 'OK' || status == 'ZERO_RESULTS'
          raise_error(response)
        end

        json['results'].map do |result|
          location = result['geometry']['location']
          coordinate = Domain::Coordinate.new(location['lat'], location['lng'])
          GooglePlace.new(result['place_id'], coordinate)
        end
      end

      private def raise_error(response)
        raise StandardError, "request to #{API_URL} failed.\nStatus: #{response.status}\nBody: #{response.body}"
      end
    end
  end
end

