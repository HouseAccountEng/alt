# frozen_string_literal: true

module Alt
  class Property
    # Reads what a home stands on and what is built into it.
    module Structure
      # The line an MLS states what the house stands on, e.g. 'Foundation Details: Slab'.
      FOUNDATION = /\AFoundation/i

      # A counted fireplace, since 'Fireplace features' describes them rather than counting.
      FIREPLACES = /\A(Number of )?Fireplaces\b[^:]*:\s*\d/i

    private

      def structure
        { 'Foundation' => foundation_of(detail(FOUNDATION)),
          'Fireplaces' => detail(FIREPLACES)&.to_i, }.compact
      end

      def foundation_of(foundation)
        return unless foundation

        case foundation
          when /slab/i then 'Slab'
          when /crawl/i then 'Crawl space'
          when /block/i then 'Block'
          when /concrete|perimeter|poured/i then 'Concrete'
          when /stone|brick/i then 'Stone'
          else 'Other'
        end
      end
    end
  end
end
