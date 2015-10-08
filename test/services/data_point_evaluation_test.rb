require "test_helper"

class DataPointEvaluationTest < ActiveSupport::TestCase
  def setup
    Aggregator.find_each(&:save)
  end

  def evaluation
    @ev ||= DataPointEvaluation.new(
              place: Place.new(geoids: ['14000US25001010100', '14000US25007990000', '14000US25023990003']),
              data_point: data_points(:total)
            )
  end

  def test_valid
    assert evaluation.valid?
  end

  def test_accepts_positional_arguments
    assert DataPointEvaluation.new(
      data_points(:total), places(:dudley)
    ).valid?
  end

  def test_asserts_needs
    assert_raises { DataPointEvaluation.new() }
    assert_raises { DataPointEvaluation.new place: places(:dudley) }
    assert_raises { DataPointEvaluation.new data_point: data_points(:total) }
  end

  def test_accepts_ids
    assert DataPointEvaluation.new(
      data_point: data_points(:total).id,
      place:      places(:dudley).id
    ).valid?
  end

  # def test_generates_sql
  #   expected = """
  #     SELECT pop25, pop25_me
  #     FROM tabular.b15002_educational_attainment_acs_ct
  #     WHERE geoid IN ('14000US25001010100')
  #       AND acs_year = '2009-13'
  #     ;
  #   """.strip!
  #   assert_equal expected, evaluation.to_sql
  # end

  def test_performs_and_returns_hash
    expected = {
      id:   "36692321",
      type: "evaluated-data-point",
      attributes: {
        title:      "Total Population",
        modifier:   "total",
        aggregator: "sum_and_moe",
        value: 2616.0,
        margin: 134.54,
        units: "residents"
      }
    }
    assert_equal expected, evaluation.perform
  end

  # def test_accepts_data_point_ids_after_creation
  #   skip
  #   evaluation.data_point = data_points(:total).id
  #   assert evaluation.valid?
  #   assert evaluation.data_point.is_a?(DataPoint), evaluation.data_point.inspect
  # end

  # def test_accepts_place_ids_after_creation
  #   skip
  #   evaluation.place = places(:dudley).id
  #   assert evaluation.valid?
  #   assert evaluation.place.is_a?(Place), evaluation.place.inspect
  # end
end
