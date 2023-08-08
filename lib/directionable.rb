# frozen_string_literal: true

require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/object/inclusion'

require_relative 'directionable/version'
require_relative 'directionable/direction'
require_relative 'directionable/compass'
require_relative 'directionable/extensions/integer'
require_relative 'directionable/extensions/float'
require_relative 'directionable/extensions/rational'

module Directionable
  class InvalidDegrees < StandardError
    
  end

  DEGREES_IN_CIRCLE = 360
  VALID_COMPASS_POINT_LENGTHS = %i[acronym full].freeze
  DEFAULT_COMPASS_POINT_LENGTH = :acronym
  VALID_COMPASS_POINTS_COUNTS = [4, 8, 16, 32].freeze
  DEFAULT_COMPASS_POINTS_COUNT = 8
  private_constant :VALID_COMPASS_POINT_LENGTHS, :VALID_COMPASS_POINTS_COUNTS,
                   :DEFAULT_COMPASS_POINT_LENGTH, :DEFAULT_COMPASS_POINTS_COUNT

  mattr_accessor :compass_point_length, default: DEFAULT_COMPASS_POINT_LENGTH, instance_writer: false, instance_reader: false
  mattr_accessor :compass_points_count, default: DEFAULT_COMPASS_POINTS_COUNT, instance_writer: false, instance_reader: false
  mattr_accessor :compass, default: Compass.new(@@compass_points_count), instance_writer: false, instance_reader: false

  def self.config
    yield(self) if block_given?
    reject_invalid_config_vals
    refresh_compass if compass.points_count != compass_points_count
    self
  end

  class Config

  end

  def degrees
    Direction.valid_degrees?(self) ? Direction.new(self, Directionable.compass) : nil
  end

  def degrees!
    Direction.new(self, Directionable.compass)
  end

  def self.reject_invalid_config_vals
    self.compass_point_length = DEFAULT_COMPASS_POINT_LENGTH unless compass_point_length.in? VALID_COMPASS_POINT_LENGTHS
    self.compass_points_count = DEFAULT_COMPASS_POINTS_COUNT unless compass_points_count.in? VALID_COMPASS_POINTS_COUNTS
  end

  def self.refresh_compass
    compass.points_count = compass_points_count
  end

  private_class_method :reject_invalid_config_vals, :refresh_compass
end
