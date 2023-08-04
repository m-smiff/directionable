# frozen_string_literal: true

module Directionable
  class Direction
    attr_reader :degrees, :compass_ref_short

    def initialize(degrees, rationalize: true)
      @degrees = rationalize ? self.class.rationalize_degrees(degrees) : degrees
      raise InvalidDegrees if !@degrees.positive? || @degrees > DEGREES_IN_CIRCLE

      @compass_ref_short = self.class.nearest_compass_ref(@degrees, rationalize: false)
    end

    def inspect
      to_s
    end

    def compass_ref
      send(compass_ref_length_method)
    end

    def self.rationalize_degrees(degrees, delta = 0)
      modulo = (degrees + delta) % DEGREES_IN_CIRCLE
      modulo.zero? ? DEGREES_IN_CIRCLE : modulo
    end

    def self.all_compass_refs
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

    def compass_ref_long
      @compass_ref_long ||= begin
        parts = compass_ref_short.to_s.split('').map do |letter|
          CARDINALS_LONG.find { |card| card.start_with?(letter) }
        end

        (parts.length > 2 ? parts.insert(1, '_').join : parts.join).to_sym
      end
    end

    def self.nearest_compass_ref(degrees, rationalize: true)
      reference = rationalize ? rationalize_degrees(degrees) : degrees
      half_cone_range = COMPASS_REFS_DELTA / 2
      return all_compass_refs.first unless reference >= half_cone_range

      ref, _dir = indexed_compass_refs.find(-> { [] }) do |_point, direction|
        ((direction - half_cone_range)...(direction + half_cone_range)).include?(reference)
      end

      ref
    end

    def self.indexed_compass_refs
      all_compass_refs.each_with_object({}).with_index do |point_and_hash, i|
        point, hash = point_and_hash
        hash[point] = rationalize_degrees(COMPASS_REFS_DELTA * i)
      end
    end
    private_class_method :indexed_compass_refs

    private

    def compass_ref_length_method
      :"compass_ref_#{Directionable.compass_ref_length}"
    end
  end
end
