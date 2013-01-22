require 'lwcsv/lwcsv'

class Lwcsv
  # file - If a String, it is treated as a filename. The file is opened,
  #        passed to #stream_foreach, and closed.
  #        Otherwise it is assumed to quack like an IO,
  #        and is passed directly to #stream_foreach
  def self.foreach(file, &block)
    if file.kind_of?(String)
      File.open(file, 'r') do |stream|
        stream_foreach(stream) { |row| yield row }
      end
    else
      stream_foreach(file) { |row| yield row }
    end
  end
end
