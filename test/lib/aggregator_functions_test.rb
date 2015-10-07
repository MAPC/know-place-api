require "test_helper"

class AggregatorFunctionsTest < ActiveSupport::TestCase

  def array
    @array ||= [1,2,3,4]
  end

  def larger_array
    @larger ||= [5,6,7,8]
  end

  def zeros
    @zeros ||= [0,1,0,2]
  end

  test "sum" do
    expected = { value: 10, margin: nil }
    assert_equal expected, AggregatorFunctions.sum( array )
  end

  test "percent" do
    expected = { value: 0.38, margin: nil }
    assert_equal expected,
      AggregatorFunctions.percent( array, larger_array )
  end

  test "median with even set" do
    expected = { value: 2.5, margin: nil }
    assert_equal expected,
      AggregatorFunctions.median( array )
  end

  test "median with odd set" do
    expected = { value: 3, margin: nil }
    assert_equal expected,
      AggregatorFunctions.median( array << 5 )
  end

  test "sum and margins" do
    expected = { value: 26, margin: 5.48 }
    assert_equal expected,
      AggregatorFunctions.sum_and_moe( larger_array, array )
  end

  test "sum and margins with zero values" do
    expected = { value: 3, margin: 5.39 }
    assert_equal expected,
      AggregatorFunctions.sum_and_moe( zeros, array )
  end

  test "percent and margins" do
    expected = { value: 0.12, margin: 20.6 }
    assert_equal expected,
      AggregatorFunctions.percent_and_moe( zeros, array, array, larger_array )
  end



end