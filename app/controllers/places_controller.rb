class PlacesController < ApplicationController
  def search
    render json: [{
                      :placeId => '99873-2',
                      :location => {:longitude=>'51.500152',:latitude=>'-0.126236'},
                      :cuisineRelevance => 0.998
                  }]
  end
end
