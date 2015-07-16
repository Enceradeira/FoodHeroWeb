require 'rails_helper'

module Search
  module Domain
    describe 'OccasionToGoogleTypeMapper' do
      let (:all_search_types) { %w(bakery cafe restaurant meal_takeaway meal_delivery bar night_club) }
      describe 'map' do
        subject { OccasionToGoogleTypeMapper.map(occasion) }

        context '#breakfast' do
          let(:occasion) { 'breakfast' }
          it { is_expected.to contain_exactly('cafe', 'bakery') }
        end

        context '#lunch' do
          let(:occasion) { 'lunch' }
          it { is_expected.to contain_exactly('restaurant', 'meal_takeaway', 'meal_delivery') }
        end

        context '#snack' do
          let(:occasion) { 'snack' }
          it { is_expected.to contain_exactly('cafe') }
        end

        context '#dinner' do
          let(:occasion) { 'dinner' }
          it { is_expected.to contain_exactly('restaurant', 'meal_takeaway', 'meal_delivery') }
        end

        context '#drink' do
          let(:occasion) { 'drink' }
          it { is_expected.to contain_exactly('bar', 'night_club') }
        end

        context '#empty' do
          let(:occasion) { '' }
          it { is_expected.to match_array(all_search_types) }
        end

        context '#nil' do
          let(:occasion) { nil }
          it { is_expected.to match_array(all_search_types) }
        end
      end
    end
  end
end