module Util
  # checks if a number is a float
  def float?(str)
    Float(str)
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
    return sum / arr.size.to_f
  end

  #find the standard devation of an arr, must be int or float
  def self.standard_deviation(arr)
    mean = mean(arr)
    variance = arr.map { |x| (x-mean)**2 }.sum / arr.size()
    return Math.sqrt(variance)
  end
end