## Usage
{{{
Lwcsv.foreach(filename_or_stream) do |row|
  rows << row
end
}}}

## Building
{{{
gem build lwcsv.gemspec && gem install lwcsv-1.0.0.gem && rake
}}}
