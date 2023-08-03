# frozen_string_literal: true

module Directionable
  class Direction
    attr_reader :degrees, :nearest_compass_point_short

    def initialize(degrees)
      @degrees = self.class.rationalize_degrees(degrees)
      @nearest_compass_point_short = self.class.nearest_compass_point(@degrees, rationalize: false)
    end

    def inspect
      "#{degrees}#{DEGREES_SYMBOL}"
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
      inspect
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

    def nearest_compass_point_long
      @nearest_compass_point_long ||= nearest_compass_point_short.to_s.split("").map do |start_letter|
        CARDINALS_LONG.find { |cardinal| cardinal.start_with?(start_letter) }
      end.join("_").to_sym
    end

    def self.nearest_compass_point(degrees, rationalize: true)
      reference = rationalize ? rationalize_degrees(degrees) : degrees
      return all_compass_points.first unless reference >= (COMPASS_POINTS_DELTA / 2)

      indexed_compass_points.find(-> { [] }) do |_point, direction|
        half_cone_range = COMPASS_POINTS_DELTA / 2
        (direction - half_cone_range)...(direction + half_cone_range).include?(reference)
      end.first
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

# ref = 9, lgp = -2.5, hgp = 20.5
