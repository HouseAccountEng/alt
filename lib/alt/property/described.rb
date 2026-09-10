# frozen_string_literal: true

module Alt
  class Property
    # Reads Realtor's `description`, which states a home's own figures and its kind.
    module Described
      # The square feet in an acre, which is the unit a lot is worth storing in.
      ACRE = 43_560.0

    private

      def described
        { 'Lot size' => acres, 'Living area' => description[:sqft],
          'Bedrooms' => description[:beds], 'Bathrooms' => description[:baths],
          'Year built' => description[:year_built], 'Stories' => description[:stories],
          'Garage spaces' => description[:garage],
          'Property type' => property_type_of(description[:type]), }.compact
      end

      def acres
        sqft = description[:lot_sqft]
        sqft / ACRE if sqft
      end

      def description = home[:description] || {}

      def property_type_of(type)
        return unless type

        case type
          when 'single_family' then 'Single family'
          when /townhome/ then 'Townhome'
          when 'condo', 'condos', 'apartment' then 'Condo'
          when 'land', 'farm' then 'Land'
          else 'Other'
        end
      end
    end
  end
end
