require 'rails_helper'

module Search::Domain
  describe 'Coordinate' do
    describe 'new' do
      context 'with String' do
        it 'should parse latitude and longitude' do
          coordinate = Coordinate.new('51.500152,-0.126236')

          expect(coordinate).to eq Coordinate.new(51.500152,-0.126236)
        end
      end

    end
  end
end