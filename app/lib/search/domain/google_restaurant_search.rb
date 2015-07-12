module Search
  module Domain
    class GoogleRestaurantSearch

      API_URL = 'https://maps.googleapis.com/maps/api/place/'
      GOOGLE_API_KEY = 'AIzaSyDL2sUACGU8SipwKgj-mG-cl3Sik1qJGjg'

      def find_places(cuisine, occasion, coordinate, radius)
        conn = Faraday.new(url: API_URL, params: {key: GOOGLE_API_KEY}, ssl: {verify: false}) do |faraday|
          faraday.adapter Faraday.default_adapter
        end
        response = conn.get 'radarsearch/json',
                            {
                                location: "#{coordinate.latitude},#{coordinate.longitude}",
                                radius: radius,
                                keyword: cuisine
                            }
        unless response.success?
          raise_error(response)
        end

        body = response.body
        json = JSON.parse(body)

        unless json['status'] == 'OK'
          raise_error(response)
        end

        json['results'].map do |result|
          location = result['geometry']['location']
          coordinate = Coordinate.new(location['lat'], location['lng'])
          GooglePlace.new(result['place_id'],coordinate,0.8)
        end
      end

      def raise_error(response)
        raise StandardError, "request to #{API_URL} failed.\nStatus: #{response.status}\nBody: #{response.body}"
      end
    end
  end
end


