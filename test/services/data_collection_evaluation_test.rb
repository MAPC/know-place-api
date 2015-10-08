require "test_helper"

class DataCollectionEvaluationTest < ActiveSupport::TestCase

  def setup
    Aggregator.find_each.map(&:save)
  end

  def evaluation
    @ev ||= DataCollectionEvaluation.new(
              place: Place.new(geoids: ['14000US25001010100', '14000US25007990000', '14000US25023990003']),
              data_collection: data_collections(:adult_ed)
            )
  end

  def test_valid
    assert evaluation.valid?
  end

  def test_accepts_positional_arguments
    assert DataCollectionEvaluation.new(
      data_collections(:adult_ed), places(:dudley)
    ).valid?
  end

  def test_asserts_needs
    assert_raises { DataCollectionEvaluation.new() }
    assert_raises { DataCollectionEvaluation.new place: places(:dudley) }
    assert_raises { DataCollectionEvaluation.new data_collection: data_collections(:adult_ed) }
  end

  def test_accepts_ids
    assert DataCollectionEvaluation.new(
      data_collection: data_collections(:adult_ed).id,
      place: places(:dudley).id
    ).valid?
  end

  def test_performs_and_returns_hash
    expected = {
      id: "274691428", type: "evaluated-data-collection",
      attributes: {
        title: "Adults and Education"
      },
      relationships: {
        "data-points" => {
          data: [
            {
              id: "36692321", type: "evaluated-data-point",
              attributes: {
                title: "Total Population",
                modifier: "total",
                aggregator: "sum_and_moe",
                value: 2616.0,
                margin: 134.54,
                units: "residents"
              }
            },
            {
              id: "885493904", type: "evaluated-data-point",
              attributes: {
                title: "Adults with Bachelor's Degree or Higher",
                modifier: "total",
                aggregator: "sum_and_moe",
                value: 1442.0,
                margin: 211.34,
                units: "degree holders"
              } # TODO bug in rounding
            }
          ]
        }
      }
    }
    assert_equal expected, evaluation.perform
  end



end
