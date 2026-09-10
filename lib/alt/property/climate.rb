# frozen_string_literal: true

module Alt
  class Property
    # Reads how a home is heated and cooled, which one line states in two parts.
    module Climate
      # The line an MLS states heating on, e.g. 'Heating Features: Forced Air, Natural Gas'.
      HEATING = /\AHeating( Features| System)?\s*:/i

      # The line it states cooling on, e.g. 'Cooling: Central Air'.
      COOLING = /\ACooling( Features)?\s*:/i

    private

      def climate
        heating = detail HEATING
        { 'Heating system' => heating_system_of(heating),
          'Heating fuel' => heating_fuel_of(heating),
          'Cooling' => cooling_of(detail(COOLING)), }.compact
      end

      def heating_system_of(heating)
        return unless heating

        case heating
          when /heat ?pump/i then 'Heat pump'
          when /(warm|forced|hot) air|forcedair/i then 'Forced air'
          when /hot water|forced water|radiator|steam|boiler/i then 'Hot water'
          when /baseboard/i then 'Baseboard'
          when /central/i then 'Central'
          else 'Other'
        end
      end

      def heating_fuel_of(heating)
        case heating
          when /electric/i then 'Electric'
          when /propane/i then 'Propane'
          when /natural gas|\bgas\b/i then 'Natural gas'
          when /\boil\b/i then 'Oil'
        end
      end

      def cooling_of(cooling)
        return unless cooling

        case cooling
          when /central|package/i then 'Central air'
          when /heat ?pump/i then 'Heat pump'
          when /wall|window|room|individual/i then 'Wall or window'
          when /evaporative/i then 'Evaporative'
          when /fan/i then 'Ceiling fan'
          else 'Other'
        end
      end
    end
  end
end
