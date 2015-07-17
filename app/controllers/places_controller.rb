class PlacesController < ApplicationController
  def search

    cuisine = params[:cuisine]
    occasion = params[:occasion]
    coordinate = Search::Domain::Coordinate.new(params[:location])

    connection = Search::Infrastructure::GoogleRadarSearch.default_connection
    radar_search = Search::Infrastructure::GoogleRadarSearch.new(connection)
    search = Search::Domain::GoogleRestaurantSearch.new(radar_search)
    repository = Search::Domain::GoogleRestaurantRepository.new(search)
    result = repository.find_places(cuisine, occasion, coordinate)

    render json: result
  end
end
