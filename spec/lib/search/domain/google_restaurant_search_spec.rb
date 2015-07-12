require 'rails_helper'

module Search::Domain
  describe 'GoogleRestaurantSearch'  do
    let(:search){Search::Domain::GoogleRestaurantSearch.new}

    describe 'find_places' do
      it 'should return something from google' do
        london = Search::Domain::Coordinate.new(51.507571, -0.127702)

        places = search.find_places 'Indian food', 'lunch', london, 10000

        expect(places).not_to be_empty
      end
    end
  end
end