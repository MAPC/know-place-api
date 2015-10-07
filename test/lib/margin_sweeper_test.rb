require "test_helper"

class MarginSweeperTest < ActiveSupport::TestCase

  test "no zero values" do
    values =  [1]
    margins = [1]
    expected = [[1],[1]]
    actual = MarginSweeper.new(values, margins).sweep
    assert_equal expected, actual
  end

  test "one zero value" do
    values =  [0,1]
    margins = [1,3]
    expected = [[0,1], [1,3]]
    actual = MarginSweeper.new(values, margins).sweep
    assert_equal expected, actual
  end

  test "duplicate zero values" do
    values =  [0,0,1]
    margins = [1,2,3]
    expected = [[0,1], [2,3]]
    actual = MarginSweeper.new(values, margins).sweep
    assert_equal expected, actual
  end

end