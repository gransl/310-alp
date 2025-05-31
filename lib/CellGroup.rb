require 'csv'
require 'set'
require_relative 'util'
require_relative 'cell'

class CellGroup
  def initialize(f)
    @data = CSV.read(f, headers: true)
    @group = []
    populate_group()
    @body_weight_arr = []
    @display_size_arr = []

    #populate body_weight_arr
    @group.each do |cell|
      num = cell.body_weight
      if (!num.nil? && num > 0 )
        @body_weight_arr << num
      end
    end

    #populate display_size_arr
    @group.each do |cell|
      num = cell.display_size
      if (!num.nil? && num > 0 )
        @display_size_arr << num
      end
    end

  end

  def populate_group()
    @data.each do |r|
      temp = Cell.new(r['oem'], r['model'], r['launch_announced'].to_i, r['launch_status'], r['body_dimensions'], r['body_weight'].to_f, r['body_sim'], r['display_type'], r['display_size'].to_f, r['display_resolution'], r['features_sensors'], r['platform_os'])
      @group << temp
    end
  end

  def check()
  end

  # returns average body weight
  def avg_body_weight()    
    ans = Util.mean(@body_weight_arr)
    # By default, Ruby returns the last operation!
    ans.round(2)
  end

  # returns body weight standard devation
  def sd_body_weight()
    ans = Util.standard_deviation(@body_weight_arr)
    return ans.round(2)
  end

  # Returns the average display size
  def avg_display_size()    
    ans = Util.mean(@display_size_arr)
    ans.round(2)
  end

  def sd_display_size()    
    ans = Util.standard_deviation(@display_size_arr)
    ans.round(2)
  end
  
  # Returns oem and model of all phones announced in given year
  def phones_announced_in_year(year)
    phones = []
    @group.each do |cell|
      if cell.launch_announced == year
        phones << [cell.oem, cell.model].join
      end
    end

    return phones
  end

  # Returns a count of number of phones for each brand
  def brand_count()
    #Check this out: this 0 means that if the key isn't in the hash yet, 
    # it will return 0 instead of nil this means...
    brand_count = Hash.new(0)
    @group.each do |cell|
      key = cell.oem.to_sym
      #... we don't have to check if the key exists, this works either way.
      brand_count[key] += 1
    end

    string = []
    brand_count.each do |brand, count|
      string << "#{brand}: #{count}"
    end

    return string.join("\n")
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

end
