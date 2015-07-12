class PlacesController < ApplicationController
  def search

    cuisine = params[:cuisine]
    occasion = params[:occasion]
    coordinate = Search::Domain::Coordinate.new(params[:location])

    result = Search::Domain::GoogleRestaurantSearch.new.find_places(cuisine,occasion,coordinate,10000)

    render json: result
  end
end
