# frozen_string_literal: true

require 'csv'
require_relative 'util'
require_relative 'cell_group'
require_relative 'cell'

# Ingests and cleans CSV data.
#
# This class reads raw CSV input, applies initial cleaning, and writes the cleaned
# data to a new CSV file. All data type conversions are handled separately by the Cell class.
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

  def ingest
    # lines = File.foreach(@file).count
    # puts "Before ingest line count: #{lines}"

    remove_duplicates
    clean_all

    # new_csv_lines = File.foreach('lib/new_csv.csv').count
    # puts "After ingest line count: #{new_csv_lines}"
  end

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

  # @return [CellGroup]
  def create_cell_group
    output_path = File.expand_path('new_csv.csv', __dir__)
    CellGroup.new(output_path)
  end

  # @return [CSV]
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

  def clean_oem
    oem = @row['oem']
    @row['oem'] = oem&.empty? || oem == '-' ? nil : oem
  end

  def clean_model
    model = @row['model']
    @row['model'] = model&.empty? || model == '-' ? nil : model
  end

  def clean_launch_ann
    launch_ann = @row['launch_announced']
    year_str = launch_ann.to_s.strip[/\b(\d{4})\b/, 1]
    @row['launch_announced'] = year_str ? year_str.to_i : nil
  end

  def clean_launch_status
    valid_status = %w[Cancelled Discontinued]
    launch_status = @row['launch_status']

    return unless !valid_status.include?(launch_status) && !launch_status&.match?(/Available\. Released \d{4}/)

    @row['launch_status'] = nil
  end

  def clean_body_dim
    body_dim = @row['body_dimensions']
    @row['body_dimensions'] = body_dim&.empty? || body_dim == '-' ? nil : body_dim
  end

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

  def clean_body_sim
    invalid_data = %w[no yes]
    body_sim = @row['body_sim']

    return unless body_sim.nil? || invalid_data.include?(body_sim.downcase)

    @row['body_sim'] = nil
  end

  def clean_display_type
    display = @row['display_type']
    @row['display_type'] = display&.empty? || display == '-' ? nil : display
  end

  def clean_display_size
    display_size = @row['display_size']
    if display_size.nil? || display_size.empty? || display_size == '-'
      @row['display_size'] = nil
      return
    end

    match = display_size.match(/\d+(\.\d+)?/)
    @row['display_size'] = match ? match[0].to_f : nil
  end

  def clean_display_resolution
    dr = @row['display_resolution']
    @row['display_resolution'] = dr.empty? || dr == '-' ? nil : dr
  end

  def clean_features_sensors
    fs = @row['features_sensors']
    return unless Util.float?(fs) || fs.nil? || fs.empty?

    @row['features_sensors'] = nil
  end

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
end
