Gem::Specification.new do |s|
  s.name        = 'lwcsv'
  s.version     = '1.0.0'
  s.date        = '2013-01-18'
  s.summary     = "Lightweight CSV"
  s.description = "A lightweight CSV parser written in C"
  s.authors     = ["Moxley Stratton"]
  s.email       = 'moxley.stratton@gmail.com'
  s.files       = Dir.glob('ext/**/*.{c,h,rb}') +
                    Dir.glob('lib/**/*.rb') +
                    Dir.glob('test/**/*.rb') +
                    %w(Rakefile lwcsv.gemspec)
  s.extensions = ['ext/lwcsv/extconf.rb']
  s.require_paths = %w(lib ext)
  s.test_files  = %w(test/test_lwcsv.rb)
  s.homepage    = 'http://rubygems.org/gems/lwcsv'
end
