# frozen_string_literal: true

require_relative "directionable/version"
require_relative "directionable/direction"
require_relative "directionable/extensions/integer"
require_relative "directionable/extensions/float"
require_relative "directionable/extensions/rational"

module Directionable
  DEGREES_RANGE = (0..360).freeze
  DEGREES_SYMBOL = "°"
  CARDINALS_LONG = %i[NORTH EAST SOUTH WEST].freeze
  CARDINALS = %i[N E S W].freeze
  INTER_CARDINALS = %i[NE SE SW NW].freeze
  SUB_INTER_CARDINALS = %i[NNE ENE ESE SSE SSW WSW WNW NNW].freeze
  COMPASS_POINTS_DELTA = (
    # Number of degrees in circle divided by number of compass points (22.5)
    DEGREES_RANGE.max / (CARDINALS.count + INTER_CARDINALS.count + SUB_INTER_CARDINALS.count).to_f
  )

  def to_dir
    Direction.new(self)
  end
end
