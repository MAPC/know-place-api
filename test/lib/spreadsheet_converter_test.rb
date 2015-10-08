require "test_helper"

class SpreadsheetConverterTest < ActiveSupport::TestCase

  def converter
    @converter ||= SpreadsheetConverter.new('test/fixtures/data_points.csv')
  end

  test "loads" do
    assert_equal 2, converter.file.count
  end

  test "loads with headers" do
    headers = converter.file.headers.join(',')
    assert_includes headers, "Topic Area"
  end

  test "produces any data points" do
    original = DataPoint.count
    converter.perform!
    final = DataPoint.count
    assert original < final, "We started with #{original} data points, and now there are #{final}."
  end

  test "produces the right number of data points" do
    # Manually count from test spreadsheet
    # Rows and data points are not one-to-one
    EXPECTED = 3
    original = DataPoint.count
    converter.perform!
    final = DataPoint.count
    assert_equal EXPECTED, (final - original)
  end

end