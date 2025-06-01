# frozen_string_literal: true

require_relative '../lib/ingestor'
require_relative '../lib/cell'
require_relative '../lib/cell_group'

file = File.expand_path('cells.csv', __dir__)

data = Ingestor.new(file)
data.ingest

cg = data.create_cell_group

puts cg.return_range(0,10)

puts "Avg. body weight (g): #{cg.avg_body_weight}"
puts "Standard deviation, body weight: #{cg.sd_body_weight}"
puts ''
puts "Avg. display size (in): #{cg.avg_display_size}"
puts "Standard devation, display size: #{cg.sd_display_size}"

year = 2018
puts "Phones announced in #{year}:"
puts ''
puts cg.phones_announced_in_year(year)

puts ''
puts 'Number of Cells from each Brand: '
puts cg.brand_count
