# frozen_string_literal: true

module Alt
  class Property
    # Reads what a home has outside its walls.
    module Grounds
      # A pool of the home's own, anchored so that a community one is not taken for one.
      POOL = /\APool/i

      # Somewhere to sit out, e.g. 'Patio And Porch Features: Covered, Deck'.
      OUTDOOR = /\A(Patio|Deck|Porch)/i

      # A fence, however the MLS spells it: 'Fencing', 'Fence YN', 'Fenced Yard'.
      FENCE = /\AFenc/i

      # An irrigation system, e.g. 'Sprinkler System'. A fire sprinkler is labeled otherwise.
      SPRINKLERS = /\ASprinkler/i

      # The four headings an MLS states where the waste goes under, e.g. 'Sewer: Public'.
      SEWER = /\A(Sewer|Septic|City Sewer|Public Sewer)/i

    private

      def grounds
        { 'Pool' => ('Yes' if detail(POOL)),
          'Outdoor living' => ('Yes' if detail(OUTDOOR)),
          'Fence' => ('Yes' if detail(FENCE)),
          'Sprinklers' => ('Yes' if detail(SPRINKLERS)),
          'Sewer' => sewer_of(detail(SEWER)), }.compact
      end

      def sewer_of(sewer)
        return unless sewer

        case sewer
          when /septic/i then 'Septic'
          when /private/i then 'Private'
          when /public|city|municipal|connected/i then 'Public'
          else 'Other'
        end
      end
    end
  end
end
