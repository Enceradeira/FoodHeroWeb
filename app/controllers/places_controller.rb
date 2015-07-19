class PlacesController < ApplicationController
  def search

    cuisine = params[:cuisine]
    occasion = params[:occasion]
    coordinate = Search::Domain::Coordinate.new(params[:location])

    radar_search = Infrastructure::Container.instance.google_radar_search
    search = Search::Domain::GoogleRestaurantSearch.new(radar_search)
    repository = Search::Domain::GoogleRestaurantRepository.new(search)
    result = repository.find_places(cuisine, occasion, coordinate)

    render json: result
  end
end
