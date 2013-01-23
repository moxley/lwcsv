require 'benchmark'
require 'csv'
require 'ccsv'
require 'lwcsv'

SMALL_FILE = 'tmp/access-fund-orders.csv'
MEDIUM_FILE = 'tmp/freeskier-magazine-orders.csv'
LARGE_FILE = 'tmp/cart_item_returns.csv'
DIFFICULT_FILE = 'tmp/et_data.csv'

# File size: 4201839
#        user     system      total        real
# CSV  1.110000   0.010000   1.120000 (  1.109585)
# Ccsv  0.060000   0.000000   0.060000 (  0.063195)
# Lwcsv  0.060000   0.000000   0.060000 (  0.066121)
def benchmark
  filename = LARGE_FILE
  puts "File size: #{File.size(filename)}"

  Benchmark.bm do |x|
    x.report('CSV') do
      CSV.foreach(filename) { |row| }
    end

    x.report('Ccsv') do
      Ccsv.foreach(filename) { |row| }
    end

    x.report('Lwcsv') do
      Lwcsv.foreach(filename) { |row| }
    end
  end
end

def parse_difficult_file(parser = :lwcsv)
  filename = DIFFICULT_FILE
  i = 0
  Ccsv.foreach(filename) do |row|
    if i == 1795
      p row
    end
    i += 1
  end
  #CSV.foreach(filename) { |row| }
end

#benchmark
#benchmark_read
parse_difficult_file
