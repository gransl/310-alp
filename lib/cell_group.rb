# frozen_string_literal: true

require 'csv'
require 'set'
require_relative 'util'
require_relative 'cell'

# Groups Cells to perform aggregate calculations and analysis.
class CellGroup
  attr_reader(:body_weight_arr, :display_size_arr)
  def initialize(file)
    @data = CSV.read(file, headers: true)
    @group = []
    populate_group
    @body_weight_arr = []
    @display_size_arr = []

    # populate body_weight_arr and display_size_arr
    @group.each(&method(:populate_field_arr))
  end

  def populate_group
    @data.each do |r|
      temp = Cell.new(r['oem'], r['model'], r['launch_announced']&.to_i, r['launch_status'],
                      r['body_dimensions'], r['body_weight']&.to_f, r['body_sim'],
                      r['display_type'],
                      r['display_size']&.to_f, r['display_resolution'], r['features_sensors'],
                      r['platform_os'])
      @group << temp
    end
  end

  def return_cell(num)
    raise ArgumentError unless num >= 0 && num < @group.size

    @group[num]
  end

  # returns average body weight
  def avg_body_weight
    ans = Util.mean(@body_weight_arr.compact)
    # By default, Ruby returns the last operation!
    ans.round(2)
  end

  # returns body weight standard deviation
  def sd_body_weight
    ans = Util.standard_deviation(@body_weight_arr.compact)
    ans.round(2)
  end

  # Returns the average display size
  def avg_display_size
    ans = Util.mean(@display_size_arr.compact)
    ans.round(2)
  end

  def sd_display_size
    ans = Util.standard_deviation(@display_size_arr.compact)
    ans.round(2)
  end

  # Returns oem and model of all phones announced in given year
  def phones_announced_in_year(year)
    phones = []
    @group.each do |cell|
      phones << [cell.oem, cell.model].join(' ') if cell.launch_announced == year
    end

    phones
  end

  # Returns a count of number of phones for each brand
  def brand_count
    # Check this out: this 0 means that if the key isn't in the hash yet,
    # it will return 0 instead of nil this means...
    brand_count = Hash.new(0)
    @group.each do |cell|
      key = cell.oem.to_sym
      # ... we don't have to check if the key exists, this works either way.
      brand_count[key] += 1
    end

    string = []
    brand_count.each do |brand, count|
      string << "#{brand}: #{count}"
    end

    string.join("\n")
  end

  # Returns a range of values from the CellGroup
  def return_range(start, stop)
    string = []
    @group[start..stop].each do |cell|
      string << cell.to_s
    end
    string.join("\n\n")
  end

  # Returns all values from the CellGroup
  def to_s
    return_range(0, @group.size)
  end

  # Returns number of cells in group
  #
  # @return [Integer] number of cells in group
  def size
    @group.size
  end

  def populate_field_arr(cell)
    num = cell.body_weight
    @body_weight_arr << num if !num.nil? && num.positive?

    num = cell.display_size
    @display_size_arr << num if !num.nil? && num.positive?
  end
end
