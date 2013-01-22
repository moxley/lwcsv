# encoding: utf-8

require 'test/unit'
require 'lwcsv'
require 'stringio'

class LwcsvTest < Test::Unit::TestCase
  def test_stream
    rows = []
    stream = StringIO.new("EmailAddress,UserID\nuser100@example.com,100")
    stream.respond_to?('readline') or raise 'stream must respond to readline'
    Lwcsv.foreach(stream) do |row|
      rows << row
    end

    assert_equal [['EmailAddress', 'UserID'], ['user100@example.com', '100']], rows
  end

  def test_file
    rows = []
    file = File.open(File.dirname(__FILE__) + '/fixtures/small.csv', 'r')
    file.kind_of?(IO) or raise "stream isn't an IO"
    Lwcsv.stream_foreach(file) do |row|
      rows << row
    end
    # user100@example.com,100,,,,,0,2012-08-08 18:48:00,2013-01-14 09:50:04,2013-01-14 09:50:04,0,0,
    expected_rows = [["EmailAddress", "UserID", "FirstName", "LastName", "DOB", "Zip", "SubscriberStatus", "SignUpDate", "UnsubscribeDate", "LastModified", "BrandEventDaily", "BrandEventWeekly", "Gender"],
                     ["user100@example.com", "100", "", "", "", "", "0", "2012-08-08 18:48:00", "2013-01-14 09:50:04", "2013-01-14 09:50:04", "0", "0", ""],
                     ["user200@example.com", "200", "", "", "", "", "0", "2012-08-27 21:55:00", "2013-01-13 14:04:17", "2013-01-13 14:04:17", "0", "0", ""],
                     ["user300@example.com", "300", "Joe \"Bob\"", "", "", "", "0", "2012-08-27 21:55:00", "2013-01-14 10:07:44", "2013-01-14 10:07:44", "0", "0", ""]]
   assert_equal rows, expected_rows
  end

  def test_bad_argument
    begin
      Lwcsv.stream_foreach(Object.new) { |r| }
      raise "Should have raised exception"
    rescue RuntimeError => e
      assert_equal e.message, 'Argument needs to respond to #readline'
    end
  end

  def test_utf8
    csv_string = 'foo,bar✓,baz'
    stream = StringIO.new(csv_string)
    expected = ['foo', 'bar✓', 'baz']
    rows = []
    Lwcsv.stream_foreach(stream) do |row|
      rows << row
    end
    assert_equal Encoding::UTF_8, rows.first.first.encoding
    assert_equal [expected], rows
  end
end
