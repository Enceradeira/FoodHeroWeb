module Search
  module Domain
    class OccasionToGoogleTypeMapper
      private
      @@cafe = %w(cafe)
      @@breakfast = %w(bakery) + @@cafe
      @@drinking = %w(bar night_club)
      @@eating = %w(restaurant meal_takeaway meal_delivery )

      class << self
        def type_for_lunch
          %w(restaurant meal_takeaway meal_delivery)
        end

        def map(occasion)
          case occasion
            when 'breakfast'
              @@breakfast
            when 'lunch'
              @@eating
            when 'snack'
              @@cafe
            when 'dinner'
              @@eating
            when 'drink'
              @@drinking
            else
              @@breakfast + @@eating + @@drinking
          end
        end
      end
    end
  end
end