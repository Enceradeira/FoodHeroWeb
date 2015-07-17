FactoryGirl.define do
  factory :coordinate, class: Search::Domain::Coordinate do
    sequence(:latitude) { |n| n.to_f/1000 + 51.507571 }
    sequence(:longitude) { |n| n.to_f/1000 - 0.127702 }
  end

  factory :google_place, class: Search::Infrastructure::GooglePlace do
    sequence(:placeId) { |n| "#{n}1a0b#{n+4}42c79826#{n+1}" }
    association :location, factory: :coordinate, strategy: :build
  end
end