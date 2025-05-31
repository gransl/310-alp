require_relative '../lib/Ingestor'
require_relative '../lib/Cell'

file = File.expand_path("cells.csv", __dir__)

data = Ingestor.new(file)

data.ingest()