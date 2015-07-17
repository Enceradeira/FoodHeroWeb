require 'rails_helper'

module Search
  module Domain
    describe RadiusCalculator do

      describe 'do_until_nr_of_results_ok' do
        let(:result_for_too_broad) { Array.new(GoogleRestaurantSearch.google_max_search_results) }
        let(:result_for_specific_and_broad) { Array.new(GoogleRestaurantSearch.google_max_search_results/2) }
        let(:result_for_too_specific) { Array.new(GoogleRestaurantSearch.google_max_search_results/3) }

        it 'should return results which is both broad and specific (nr >= 50% < 100% of max.search results)' do
          fetched_results = [result_for_too_broad, result_for_specific_and_broad, result_for_too_specific]
          results = RadiusCalculator.do_until_nr_of_results_ok do |_|
            fetched_results.shift
          end

          expect(results.length).to be == result_for_specific_and_broad.length
        end

        it 'should decrease search radius when result not specific enough (nr= max. search results)' do
          radii = []
          fetched_results = [result_for_too_broad, result_for_too_broad, result_for_too_broad, result_for_too_broad, result_for_specific_and_broad]
          RadiusCalculator.do_until_nr_of_results_ok do |radius|
            radii << radius
            fetched_results.shift
          end

          isr = RadiusCalculator.initial_search_radius
          ird = RadiusCalculator.initial_radius_decrease
          expect(radii[0]).to be == isr
          expect(radii[1]).to be == isr - ird
          expect(radii[2]).to be == isr - ird - (ird/2)
          expect(radii[3]).to be == isr - ird - (ird/2) - (ird/4)
        end

        it 'should increase search radius when result is not broad enough (nr< 50% max. search results)' do
          radii = []
          fetched_results = [result_for_too_specific, result_for_too_specific, result_for_too_specific, result_for_too_specific, result_for_specific_and_broad]
          RadiusCalculator.do_until_nr_of_results_ok do |radius|
            radii << radius
            fetched_results.shift
          end

          isr = RadiusCalculator.initial_search_radius
          ri = RadiusCalculator.radius_increase
          expect(radii[0]).to be == isr
          expect(radii[1]).to be == isr + ri
          expect(radii[2]).to be == isr + ri+ ri
          expect(radii[3]).to be == isr + ri+ ri+ ri
        end

        it 'should return last results when search radius reaches max. search radius' do
          radii = []
          result_at_max_radius = result_for_too_specific + Array.new(10)
          result = RadiusCalculator.do_until_nr_of_results_ok do |radius|
            radii << radius
            if radius < GoogleRestaurantSearch.google_max_search_radius
              # too specific lets algorithm increase radius
              result_for_too_specific
            else
              result_at_max_radius
            end
          end

          expect(result.length).to be == result_at_max_radius.length
          expect(radii.last).to be == GoogleRestaurantSearch.google_max_search_radius
        end

        it 'should stop searching when radius cant be decreased anymore' do
          radii = []
          result = RadiusCalculator.do_until_nr_of_results_ok do |radius|
            radii << radius
            # too broad lets to radius being decreased
            result_for_too_broad
          end

          expect(result.length).to be == result_for_too_broad.length
          expect(radii.last).to be_between(0,1000)
        end
      end
    end
  end
end