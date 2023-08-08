# frozen_string_literal: true

module Directionable
  class Compass
    class Point
      QUARTER_WINDS_SEPARATOR = :BY
      PARTS_SEPARATOR = '_'

      attr_reader :acronym, :degrees_range

      def initialize(acronym, degrees, interval)
        @acronym = acronym
        plus_minus = interval / 2
        @degrees_range = (degrees - plus_minus)...(degrees + plus_minus)
      end

      def inspect
        full.to_s
      end

      def full
        @full ||= begin
          parts = acronym.to_s.split('').map do |letter|
            (CARDINALS_FULL + [QUARTER_WINDS_SEPARATOR]).find { |el| el.start_with?(letter.upcase) }
          end

          join_parts(parts)
        end
      end

      private

      def join_parts(parts)
        parts.insert(1, PARTS_SEPARATOR) if parts.length > 2 && !parts.include?(QUARTER_WINDS_SEPARATOR)
        if parts.include?(QUARTER_WINDS_SEPARATOR)
          parts.insert(parts.index(QUARTER_WINDS_SEPARATOR), PARTS_SEPARATOR)
          parts.insert(parts.index(QUARTER_WINDS_SEPARATOR) + 1, PARTS_SEPARATOR)
        end
        parts.join.to_sym
      end
    end
  end
end
