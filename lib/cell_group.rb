# frozen_string_literal: true

require 'csv'
require_relative 'util'
require_relative 'cell'

# Groups Cells to perform aggregate calculations and analysis.
class CellGroup
  attr_reader :body_weight_arr, :display_size_arr

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
  def avg_body_weight(num_arr = @body_weight_arr)
    ans = Util.mean(num_arr)
    # By default, Ruby returns the last operation!
    ans.round(2)
  end

  # returns average body weight by company (oem)
  def avg_body_weight_by_company(oem)
    phones_bw = []

    @group.each do |row|
      phones_bw << row.body_weight if row.oem.downcase == oem.downcase && row.body_weight
    end
    avg_body_weight(phones_bw)
  end

  # Question 1: returns company with the largest average body weight
  # @return [Array] company name, max average body weight
  def max_avg_body_weight_by_company
    brands = brand_list
    max_avg_wt = 0
    brand_max = ''

    brands.each do |brand|
      temp_wt = avg_body_weight_by_company(brand)
      if temp_wt > max_avg_wt
        max_avg_wt = temp_wt
        brand_max = brand
      end
    end

    [brand_max, max_avg_wt]
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

  # Returns a list of phones released in a year different from their announcement.
  def announce_yr_different_than_release_yr
    phones = []

    @group.each do |cell|
      if cell.launch_status&.include?('Available')
        launch_year = cell.launch_status.to_s.strip[/\b(\d{4})\b/, 1].to_i
        phones << [cell.oem, cell.model].join(' ') unless cell.launch_announced == launch_year
      end
    end

    phones
  end

  # returns a list of the count of phones launched in every year since 1999
  def phone_count_per_year
    year_count = Hash.new(0)

    @group.each do |cell|
      next unless cell.launch_status&.include?('Available')

      launch_year = cell.launch_status.to_s.strip[/\b(\d{4})\b/, 1]
      key = launch_year.to_sym
      year_count[key] += 1
    end

    year_count
  end

  # Returns a list of all brands (oem) in the cell group
  def brand_list
    brand_list = []

    @group.each do |cell|
      brand_list << cell.oem unless brand_list.include?(cell.oem)
    end

    brand_list
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

  # TODO: change if V1 isn't a feature
  # Returns a list of phones that only have one feature sensor
  def one_feature_phone_count
    one_feature_phone_count = 0

    @group.each do |cell|
      features_arr = cell.features_sensors&.split(' ')
      one_feature_phone_count += 1 if features_arr&.size == 1
    end

    one_feature_phone_count
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
