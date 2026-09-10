# frozen_string_literal: true

module Alt
  class Property
    # Reads Realtor's `details`, whose lines are sentences labeled by what they state.
    module Detailed
    private

      def detail(label)
        line = detail_lines.grep(label).first
        line.split(':', 2).last.strip if line
      end

      def detail_lines
        Array(home[:details]).flat_map { |one| Array one[:text] }
      end
    end
  end
end
