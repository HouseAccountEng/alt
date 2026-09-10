# frozen_string_literal: true

module Alt
  class Property
    # Reads what a home is roofed and clad with.
    module Exterior
      # The line an MLS states a roof on, e.g. 'Roof: Asphalt Shingle'.
      ROOF = /\ARoof(ing)?\s*:/i

      # The three headings it files the walls under, e.g. 'Construction Materials: Brick'.
      CONSTRUCTION = /\A(Construction Materials|Building Exterior Type|Exterior)\s*:/i

    private

      def exterior
        { 'Roof' => roof_of(detail(ROOF)),
          'Construction' => construction_of(detail(CONSTRUCTION)), }.compact
      end

      def roof_of(roof)
        return unless roof

        case roof
          when /tile/i then 'Tile'
          when /slate|slag/i then 'Slate'
          when /metal|corrugated/i then 'Metal'
          when /wood|shake|cedar/i then 'Wood'
          when /shingle|asphalt|composition|fiberglass/i then 'Asphalt shingle'
          else 'Other'
        end
      end

      def construction_of(construction)
        return unless construction

        case construction
          when /brick/i then 'Brick'
          when /vinyl/i then 'Vinyl'
          when /wood|cedar|clapboard|shake|frame/i then 'Wood'
          when /aluminum/i then 'Aluminum'
          when /stucco|plaster|stone|concrete|block|cement|hardi/i then 'Masonry'
          else 'Other'
        end
      end
    end
  end
end
