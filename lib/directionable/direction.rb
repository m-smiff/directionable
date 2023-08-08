# frozen_string_literal: true

module Directionable
  class Direction
    DEGREES_SYMBOL = '°'

    attr_reader :degrees

    def initialize(degrees, compass)
      raise TypeError unless degrees.respond_to? :to_i

      @degrees = degrees
      raise InvalidDegrees unless valid?

      @compass = compass
    end

    def self.valid_degrees?(num)
      num.positive? && num <= DEGREES_IN_CIRCLE
    end

    def inspect
      to_s
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
      self.class.new(rationalize_degrees(degrees, other), @compass)
    end

    def -(other)
      self.class.new(rationalize_degrees(degrees, -other), @compass)
    end

    def compass_point
      @compass_point ||= @compass.nearest_point(self).send(compass_point_length_method)
    end

    def compass_point_acronym
      @compass_point_acronym ||= @compass.nearest_point(self).acronym
    end

    def compass_point_full
      @compass_point_full ||= @compass.nearest_point(self).full
    end

    private

    def valid?
      self.class.valid_degrees?(degrees)
    end

    def rationalize_degrees(degs, delta = 0)
      modulo = (degs + delta) % DEGREES_IN_CIRCLE
      modulo.zero? ? DEGREES_IN_CIRCLE : modulo
    end

    def compass_point_length_method
      Directionable.compass_point_length
    end
  end
end
