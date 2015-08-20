require "test_helper"

class DataPointTest < ActiveSupport::TestCase
  def data_point
    @data_point ||= data_points(:total)
  end

  def test_valid
    assert data_point.valid?
  end

  def test_relates_to_fields
    assert_respond_to data_point, :fields
  end
end
