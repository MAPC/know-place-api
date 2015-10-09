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

  def bapl
    @bapl ||= [0, 10, 0, 5]
  end

  def bapl_me
    @bapl_me ||= [17, 5, 12, 2]
  end

  def adults
    @adults ||= [100, 200, 300, 50]
  end

  def adults_me
    @adults_me ||= [10, 12, 15, 5]
  end


  test "sum" do
    expected = { value: 10, margin: nil }
    assert_equal expected, AggregatorFunctions.sum( array )
  end

  test "percent" do
    expected = { value: 0.3846, margin: nil }
    assert_equal expected,
      AggregatorFunctions.percent( array, larger_array )

    percent = { value: 0.0231, margin: nil }
    assert_equal percent,
      AggregatorFunctions.percent(bapl, adults)
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

    sum_subset = { value: 15, margin: 17.83 }
    assert_equal sum_subset,
      AggregatorFunctions.sum_and_moe(bapl, bapl_me)

    sum_universe = { value: 650, margin: 22.23 }
    assert_equal sum_universe,
      AggregatorFunctions.sum_and_moe(adults, adults_me)
  end

  test "sum and margins with zero values" do
    expected = { value: 3, margin: 5.39 }
    assert_equal expected,
      AggregatorFunctions.sum_and_moe( zeros, array )
  end


  test "percent and margins" do
    expected = { value: 0.0231, margin: 0.0274 }
    assert_equal expected,
      AggregatorFunctions.percent_and_moe( bapl, bapl_me, adults, adults_me )
  end

  test "percent and margins when universe == subset" do
    expected = { value: 1.0, margin: 1.1887 }
    assert_equal expected,
      AggregatorFunctions.percent_and_moe( bapl, bapl_me, bapl, adults_me )
  end

  test "percent and margins when function under root is negative" do
    # The root is negative in this example, testing the sign-swap case
    # in AggregatorFunctions#_percent_moe
    # under_the_root => -999998.0119
    expected = { value: 1000, margin: 1000.0001 }
    assert_equal expected,
      AggregatorFunctions.percent_and_moe( [1000,0,0,0], [1,1,0,0], [1,0,0,0], [1,0,0,0] )
  end

  test "percent and margins when zero margin" do
    assert_nothing_raised {
      AggregatorFunctions.percent_and_moe( bapl, [0,0,0,0], bapl, adults_me )
    }
  end

  test "percent and margins when zero universe" do
    assert_nothing_raised {
      AggregatorFunctions.percent_and_moe( bapl, bapl_me, [0,0,0,0], adults_me )
    }
  end


end