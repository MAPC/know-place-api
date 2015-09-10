require "test_helper"

class DataCollectionEvaluationTest < ActiveSupport::TestCase
  def evaluation
    @ev ||= DataCollectionEvaluation.new(
              place: Place.new(geoids: ['14000US25001010100']),
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
              id:   "36692321", type: "evaluated-data-point",
              attributes: { title: "Total Population", modifier: "total", aggregator: "sum_and_moe", value: 10543.0, margin: 270.98 }
            },
            {
              id: "885493904", type: "evaluated-data-point",
              attributes: { title: "Adults with Bachelor's Degree or Higher", modifier: "total", aggregator: "sum_and_moe", value: 6023.0, margin: 499.33}
            }
          ]
        }
      }
    }
    assert_equal expected, evaluation.perform
  end



end
