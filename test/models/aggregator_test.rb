require "test_helper"

class AggregatorTest < ActiveSupport::TestCase
  def aggregator
    @aggregator ||= aggregators(:sum_and_moe)
  end

  def test_valid
    assert aggregator.valid?, aggregator.errors.full_messages
  end

  def test_requires_a_name
    aggregator.name = ""
    assert_not aggregator.valid?
  end

  def test_requires_a_name_of_certain_length
    aggregator.name = "x" * 2
    assert_not aggregator.valid?
    aggregator.name = "x" * 141
    assert_not aggregator.valid?
  end

  def test_relates_to_data_points
    assert_respond_to aggregator, :data_points
  end

end
