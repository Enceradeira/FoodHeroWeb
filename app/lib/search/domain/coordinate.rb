module Search
  module Domain
    class Coordinate < Struct.new(:latitude, :longitude)
      def initialize(*args)
        if args.length == 1
          match = /^(.*),(.*)$/.match(args[0])
          latitude = match[1]
          longitude = match[2]
          unless latitude.nil? || longitude.nil?
            super(latitude.to_f, longitude.to_f)
            return
          end
        end
        super(*args)
      end
    end
  end
end
