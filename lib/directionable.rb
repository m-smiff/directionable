# frozen_string_literal: true

require_relative 'directionable/version'
require_relative 'directionable/direction'
require_relative 'directionable/extensions/integer'
require_relative 'directionable/extensions/float'
require_relative 'directionable/extensions/rational'

module Directionable
  class InvalidDegrees < StandardError; end

  DEGREES_IN_CIRCLE = 360
  DEGREES_SYMBOL = '°'
  CARDINALS_LONG = %i[NORTH EAST SOUTH WEST].freeze
  CARDINALS = %i[N E S W].freeze
  INTER_CARDINALS = %i[NE SE SW NW].freeze
  SUB_INTER_CARDINALS = %i[NNE ENE ESE SSE SSW WSW WNW NNW].freeze
  COMPASS_REFS_DELTA = (
    # Number of degrees in circle (360) divided by number of compass points (16) => 22.5
    DEGREES_IN_CIRCLE / (CARDINALS.count + INTER_CARDINALS.count + SUB_INTER_CARDINALS.count).to_f
  )
  VALID_COMPASS_REF_LENGTHS = %i[short long].freeze

  @compass_ref_length = VALID_COMPASS_REF_LENGTHS.first

  def self.compass_ref_length
    @compass_ref_length
  end

  def self.compass_ref_length=(length)
    @compass_ref_length = length if VALID_COMPASS_REF_LENGTHS.include?(length)
  end

  def self.config
    yield(self) if block_given?
    self
  end

  def to_dir!
    Direction.new(self, rationalize: false)
  end
  alias degrees! to_dir!

  def to_dir
    Direction.new(self)
  end
  alias degrees to_dir
end
