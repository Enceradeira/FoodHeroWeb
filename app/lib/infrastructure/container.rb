module Infrastructure
  class Container
    include Singleton

    attr_accessor :google_radar_search

    def initialize
      connection = Search::Infrastructure::GoogleRadarSearch.default_connection
      @google_radar_search = Search::Infrastructure::GoogleRadarSearch.new(connection)
    end
  end
end