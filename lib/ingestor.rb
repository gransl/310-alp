# frozen_string_literal: true

require 'csv'
require_relative 'util'
require_relative 'cell_group'
require_relative 'cell'

# Ingests and cleans CSV data.
#
# This class reads raw CSV input, applies initial cleaning, and writes the cleaned
# data to a new CSV file. All data type conversions are handled separately by the Cell class.
# This is specific for one CSV and would not apply generally any CSV
#
# @see Cell for data type conversion
class Ingestor
  include Util

  def initialize(file)
    raise ArgumentError, 'File does not exist' unless File.exist?(file)
    raise ArgumentError, 'File is empty' if File.zero?(file)

    @file = file
    @data = CSV.read(@file, headers: true)
    @row = nil
  end

  # Cleans the CSV and removes duplicates
  # @return [CSV]
  def ingest
    remove_duplicates
    clean_all
  end

  # Creates a cell group for the cleaned CSV data
  #
  # @return [CellGroup] associated with this CSV
  def create_cell_group
    output_path = File.expand_path('new_csv.csv', __dir__)
    CellGroup.new(output_path)
  end

  private

  # Cleans all the data
  def clean_all
    @data.each do |row|
      @row = row
      clean_oem
      clean_model
      clean_launch_ann
      clean_launch_status
      clean_body_dim
      clean_body_wt
      clean_body_sim
      clean_display_type
      clean_display_size
      clean_features_sensors
      clean_platform_os
    end

    CSV.open(@file, 'w', write_headers: true, headers: @data.headers) do |csv|
      @data.each do |row|
        csv << row
      end
    end
  end

  # Cleans oem data
  def clean_oem
    oem = @row['oem']
    @row['oem'] = oem&.empty? || oem == '-' ? nil : oem
  end

  # Cleans model data
  def clean_model
    model = @row['model']
    @row['model'] = model&.empty? || model == '-' ? nil : model
  end

  # Cleans launch_announcement data
  def clean_launch_ann
    launch_ann = @row['launch_announced']
    year_str = launch_ann.to_s.strip[/\b(\d{4})\b/, 1]
    @row['launch_announced'] = year_str ? year_str.to_i : nil
  end

  # Cleans launch_status data
  def clean_launch_status
    valid_status = %w[Cancelled Discontinued]
    launch_status = @row['launch_status']

    return unless !valid_status.include?(launch_status) && !launch_status&.match?(/Available\. Released \d{4}/)

    @row['launch_status'] = nil
  end

  # Cleans body dimension data
  def clean_body_dim
    body_dim = @row['body_dimensions']
    @row['body_dimensions'] = body_dim&.empty? || body_dim == '-' ? nil : body_dim
  end

  # Cleans body weight data
  def clean_body_wt
    wt_str = @row['body_weight']
    if wt_str.nil? || wt_str.empty? || wt_str == '-'
      @row['body_weight'] = nil
    else
      idx = wt_str.index('g') || wt_str.index('(')
      @row['body_weight'] = if idx.nil?
                              nil
                            else
                              wt_str[0, idx].strip.to_f
                            end
    end
  end

  # Cleans body sim data
  def clean_body_sim
    invalid_data = %w[no yes]
    body_sim = @row['body_sim']

    return unless body_sim.nil? || invalid_data.include?(body_sim.downcase)

    @row['body_sim'] = nil
  end

  # Cleans display type data
  def clean_display_type
    display = @row['display_type']
    @row['display_type'] = display&.empty? || display == '-' ? nil : display
  end

  # Cleans display_size data
  def clean_display_size
    display_size = @row['display_size']
    if display_size.nil? || display_size.empty? || display_size == '-'
      @row['display_size'] = nil
      return
    end

    match = display_size.match(/\d+(\.\d+)?/)
    @row['display_size'] = match ? match[0].to_f : nil
  end

  # Cleans display resolution data
  def clean_display_resolution
    dr = @row['display_resolution']
    @row['display_resolution'] = dr.empty? || dr == '-' ? nil : dr
  end

  # Cleans features sensors data
  def clean_features_sensors
    fs = @row['features_sensors']
    return unless Util.float?(fs) || fs.nil? || fs.empty?

    @row['features_sensors'] = nil
  end

  # Cleans platform os data
  def clean_platform_os
    os = @row['platform_os']
    if os.nil? || Util.float?(os)
      @row['platform_os'] = nil
    else
      os_idx = os.index(',')
      @row['platform_os'] = if os_idx.nil?
                              os
                            else
                              os[0, os_idx]
                            end
    end
  end

  # removes duplicate rows from the CSV
  def remove_duplicates
    output_path = File.expand_path('new_csv.csv', __dir__)

    # need to compare hashes because the rows are seen different objects
    unique_rows = @data.uniq(&:to_h)

    # create new CSV without duplicate data
    CSV.open(output_path, 'w') do |csv|
      csv << @data.headers
      unique_rows.each do |row|
        csv << row
      end
    end

    @file = 'lib/new_csv.csv'
    @data = CSV.read(@file, headers: true)
  end
end
