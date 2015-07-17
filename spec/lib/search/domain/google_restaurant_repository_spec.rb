require 'rails_helper'

module Search::Domain
  describe GoogleRestaurantRepository do

    describe 'find_places' do
      let(:repository) { GoogleRestaurantRepository.new(restaurant_search) }
      let(:coordinate) { build(:coordinate) }
      let(:default_search_radius) { RadiusCalculator.initial_search_radius }

      context 'with restaurant_search-spy' do
        let(:restaurant_search) { spy() }

        it 'should call RestaurantSearch with correct cuisine, occassion and coordinate' do
          repository.find_places('Indian', 'lunch', coordinate)

          expect(restaurant_search).to have_received(:find_places).with('Indian', 'lunch', coordinate, default_search_radius)
        end
      end

      context 'with restaurant_search-stub' do
        let(:restaurant_search) { stub() }
      end
    end
  end
end