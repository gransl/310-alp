# frozen_string_literal: true
# Class of calculations for Cell and CellGroup
module Util
  # checks if a number is a float
  def self.float?(val)
    Float(val)
    true
  rescue ArgumentError
    false
  end

  # find the mean of an arr , must be int or float
  def self.mean(arr)
    sum = 0
    arr.each do |num|
      sum += num
    end
    sum / arr.size.to_f
  end

  # find the standard deviation of an arr, must be int or float
  def self.standard_deviation(arr)
    mean = mean(arr)
    variance = arr.map { |x| (x - mean)**2 }.sum / (arr.size - 1)
    Math.sqrt(variance)
  end
end
