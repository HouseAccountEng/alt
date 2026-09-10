# frozen_string_literal: true

module Alt
  class Property
    # Reads where Realtor says the home stands, which a host pins with rather than keeps.
    module Placed
    private

      def placed
        { 'Coordinate' => coordinate.values_at(:lat, :lon) }
      end

      def coordinate = home.dig(:location, :address, :coordinate) || {}
    end
  end
end
