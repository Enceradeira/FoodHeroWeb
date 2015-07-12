class PlacesController < ApplicationController
  def search

    result = Search::Domain::GoogleRestaurantSearch.new.find_places '','',''

    render json: result
  end
end
