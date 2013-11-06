# About
A lightweight CSV parser for Ruby applications. It parses a subset of the CSV standard.
Being written in C, it is quite fast.

Features NOT implemented:
* Quoted fields
* Character encodings other than 8-bit or utf-8

## Installation
Add to your Gemfile:
```
gem 'lwcsv', :git => 'https://github.com/moxley/lwcsv.git'
```

## Usage
```
Lwcsv.foreach(filename_or_stream) do |row|
  rows << row
end
```

If given a stream, the object must provide the `#eof?` and `#getline` methods.

## Building

Only needed when making changes to the source.

```
gem build lwcsv.gemspec && gem install lwcsv-1.0.0.gem && rake
```
