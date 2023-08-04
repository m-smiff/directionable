# frozen_string_literal: true

module Directionable
  class Direction
    attr_reader :degrees, :compass_point

    def initialize(degrees)
      @degrees = self.class.rationalize_degrees(degrees)
      @compass_point = self.class.nearest_compass_point(@degrees, rationalize: false)
    end

    def inspect
      to_s
    end

    def self.max
      DEGREES_RANGE.max
    end

    def self.rationalize_degrees(degrees, delta = 0)
      modulo = (degrees + delta) % max
      modulo.zero? ? max : modulo
    end

    def self.all_compass_points
      CARDINALS.zip(INTER_CARDINALS).flatten.zip(SUB_INTER_CARDINALS).flatten
    end

    def to_s
      "#{degrees}#{DEGREES_SYMBOL}"
    end

    def to_i
      degrees.to_i
    end

    def to_f
      degrees.to_f
    end

    def to_r
      degrees.to_r
    end

    def +(other)
      self.class.new(self.class.rationalize_degrees(degrees, other))
    end

    def -(other)
      self.class.new(self.class.rationalize_degrees(degrees, -other))
    end

    def compass_point_long
      @compass_point_long ||= begin
        parts = compass_point.to_s.split('').map do |letter|
          CARDINALS_LONG.find { |card| card.start_with?(letter) }
        end

        (parts.length > 2 ? parts.insert(1, '_').join : parts.join).to_sym
      end
    end

    def self.nearest_compass_point(degrees, rationalize: true)
      reference = rationalize ? rationalize_degrees(degrees) : degrees
      half_cone_range = COMPASS_POINTS_DELTA / 2
      return all_compass_points.first unless reference >= half_cone_range

      point, _dir = indexed_compass_points.find(-> { [] }) do |_point, direction|
        ((direction - half_cone_range)...(direction + half_cone_range)).include?(reference)
      end

      point
    end

    def self.indexed_compass_points
      all_compass_points.each_with_object({}).with_index do |point_and_hash, i|
        point, hash = point_and_hash
        hash[point] = rationalize_degrees(COMPASS_POINTS_DELTA * i)
      end
    end
    private_class_method :indexed_compass_points
  end
end
