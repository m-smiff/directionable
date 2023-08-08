# frozen_string_literal: true

require_relative 'compass/point'

module Directionable
  class Compass
    CARDINALS_FULL = %i[NORTH EAST SOUTH WEST].freeze
    CARDINALS = %i[N E S W].freeze
    ORDINALS = %i[NE SE SW NW].freeze
    HALF_WINDS = %i[NNE ENE ESE SSE SSW WSW WNW NNW].freeze
    QUARTER_WINDS = %i[NbE NEbN NEbE EbN EbS SEbE SEbS SbE SbW SWbS SWbW WbS WbN NWbW NWbN NbW].freeze
    ALL_POINTS = CARDINALS.zip(ORDINALS).flatten.zip(HALF_WINDS).flatten.zip(QUARTER_WINDS).flatten.freeze

    attr_accessor :points_count

    def initialize(points_count)
      @points_count = points_count
    end

    def nearest_point(direction)
      points.find { |point| point.degrees_range.include? direction.degrees }
    end

    private

    def points_interval
      DEGREES_IN_CIRCLE / points_count.to_f
    end

    def points
      return @points unless @points.nil? || @points.count != points_count

      @points = applicable_points_acronyms.map do |point|
        Point.new(point, degrees_for_point(point), points_interval)
      end
    end

    def applicable_points_acronyms
      @applicable_points_acronyms ||= ALL_POINTS.each_slice(ALL_POINTS.count / @points_count).map { |points| points[0] }
    end

    def degrees_for_point(point_acronym)
      return DEGREES_IN_CIRCLE.to_f if ALL_POINTS.first == point_acronym

      applicable_points_acronyms.index(point_acronym) * points_interval
    end
  end
end
