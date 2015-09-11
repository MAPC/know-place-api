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

  # def test_requires_an_operation
  #   aggregator.operation = ""
  #   assert_not aggregator.valid?
  # end

  # def test_requires_an_operation_of_certain_length
  #   aggregator.operation = "x" * 9
  #   assert_not aggregator.valid?
  #   aggregator.operation = "x" * 1001
  #   assert_not aggregator.valid?
  # end

  # def test_requires_valid_sql_or_plpgsql
  #   skip "This is a difficult challenge."
  #   aggregator.operation = "SELERCT 1 as a;"
  #   assert_not aggregator.valid?
  # end

  def test_relates_to_data_points
    assert_respond_to aggregator, :data_points
  end

  # def test_requires_return_type
  #   aggregator.return_type = ""
  #   assert_not aggregator.valid?
  # end

  # def test_limits_return_types
  #   aggregator.return_type = "not_a_real_type"
  #   assert_not aggregator.valid?
  # end

#   def test_to_function_definition
#     expected_sql = """
#       CREATE OR REPLACE FUNCTION contrib_kp_inc(IN i integer, IN val integer)
#       RETURNS integer AS
#       $$
#         BEGIN
#   RETURN i + val;
# END

#       $$
#       LANGUAGE plpgsql VOLATILE NOT LEAKPROOF;

#       COMMENT ON FUNCTION public.contrib_kp_inc(IN integer, IN integer)
#       IS 'Increases an integer by a value. Contributed by KnowPlace (mapc.org).';
#     """.strip
#     assert_equal expected_sql, aggregator.to_function_definition
#   end

  # def test_to_function
  #   expected = "contrib_kp_inc(IN i integer, IN val integer)"
  #   assert_equal expected, aggregator.to_function
  # end

  # def test_params_array
  #   expected = [{direction: "IN", name: "i", type: "integer"}, {direction: "IN", name: "val", type: "integer"}]
  #   assert_equal expected, aggregator.params
  # end

end
