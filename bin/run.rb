require_relative '../lib/Ingestor'
require_relative '../lib/Cell'
require_relative '../lib/CellGroup'

file = File.expand_path("cells.csv", __dir__)

data = Ingestor.new(file)
data.ingest()

cg = CellGroup.new('new_new.csv')
