# About
A lightweight CSV parser for Ruby applications. It parses a subset of the CSV standard.
Being written in C, it is quite fast.

Features NOT implemented:
* Quoted fields
* Multibyte character encodings

## Usage

  Lwcsv.foreach(filename_or_stream) do |row|
    rows << row
  end

If given a stream, the object must provide the `#eof?` and `#getline` methods.

## Building

  gem build lwcsv.gemspec && gem install lwcsv-1.0.0.gem && rake

