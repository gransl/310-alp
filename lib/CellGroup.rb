require 'csv'
require_relative 'Cell'

class CellGroup
  def initialize(f)
    @data = CSV.read(f, headers: true)
    @group = populate_group()
  end

  def populate_group()
    @data.each do |r|
      temp = Cell.new(r['oem'], r['model'], r['launch_announced'], r['launch_status'], r['body_dimensions'], r['body_weight'], r['body_sim'],
      r['display_type'], r['display_size'], r['display_resolution'], r['features_sensors'], r['platform_os'])
      @group << temp
    end
  end

end