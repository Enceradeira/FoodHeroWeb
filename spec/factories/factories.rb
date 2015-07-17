FactoryGirl.define do
  factory :coordinate, class: Search::Domain::Coordinate do
    sequence(:latitude) { |n| n.to_f/1000 + 51.507571 }
    sequence(:longitude) { |n| n.to_f/1000 - 0.127702 }
  end

  factory :google_place, class: Search::Infrastructure::GooglePlace do
    sequence(:placeId) { |n| "#{n}1a0b#{n+4}42c79826#{n+1}" }
    association :location, factory: :coordinate, strategy: :build
  end

  factory :place_with_relevance, class: Search::Domain::PlaceWithRelevance do
    sequence(:placeId) { |n| "#{n}1a0b#{n+4}42c79826#{n+1}" }
    association :location, factory: :coordinate, strategy: :build
    sequence(:cuisineRelevance) { |n| [1.0 - (n.to_f/100)+0.01, 0].max }
  end
end