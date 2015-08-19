require "test_helper"

class AggregatorTest < ActiveSupport::TestCase
  def aggregator
    @aggregator ||= aggregators(:sum)
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

  def test_requires_an_operation
    aggregator.operation = ""
    assert_not aggregator.valid?
  end

  def test_requires_an_operation_of_certain_length
    aggregator.operation = "x" * 9
    assert_not aggregator.valid?
    aggregator.operation = "x" * 1001
    assert_not aggregator.valid?
  end

  def test_rejects_invalid_sql
    aggregator.operation = "SELERCT 1 as a;"
    assert_not aggregator.valid?
  end

  def test_relates_to_fields
    assert_respond_to aggregator, :fields
  end
end
