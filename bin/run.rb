# frozen_string_literal: true

require_relative '../lib/ingestor'
require_relative '../lib/cell'
require_relative '../lib/cell_group'

file = File.expand_path('cells.csv', __dir__)

data = Ingestor.new(file)
data.ingest
cg = data.create_cell_group

# # Question 1
puts 'Max Average Body Weight by company: '
print cg.max_avg_body_weight_by_company

# # Question 2
puts 'List of phones released in a year different from their announcement:'
print cg.announce_yr_different_than_release_yr

# # Question 3
puts 'Count of phones with only one feature sensor:'
print cg.one_feature_phone_count

# # Question 4
puts 'Phone Launch count per year: '
x = cg.phone_count_per_year
print x
x.each do |year, count|
  puts "#{year} : #{count}"
end

# Other functions
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
