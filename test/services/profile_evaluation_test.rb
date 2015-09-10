require "test_helper"

class ProfileEvaluationTest < ActiveSupport::TestCase
  def evaluation
    @ev ||= ProfileEvaluation.new(profile: profiles(:dtod))
  end

  def test_valid
    assert evaluation.valid?
  end

  def test_accepts_positional_arguments
    assert ProfileEvaluation.new(
      profiles(:dtod)
    ).valid?
  end

  def test_asserts_needs
    assert_raises { ProfileEvaluation.new() }
    assert_raises { ProfileEvaluation.new profile: Profile.new }
    assert_raises { ProfileEvaluation.new }
  end

  def test_accepts_ids
    assert ProfileEvaluation.new(
      profile: profiles(:dtod).id
    ).valid?
  end

  def test_performs_and_returns_hash
    expected = expected_evaluated_profile
    assert_equal expected, evaluation.perform
  end



  def expected_evaluated_profile
    {
      data: [
        {
          id: "36692321", type: "evaluated-data-point",
          attributes: {title: "Total Population", modifier: "total", aggregator: "sum_and_moe", value: 10543.0, margin: 270.98}
        },
        {
          id: "885493904", type: "evaluated-data-point",
          attributes: {title: "Adults with Bachelor's Degree or Higher", modifier: "total", aggregator: "sum_and_moe", value: 6023.0, margin: 499.33}
        },
        {
          id: "274691428", type: "evaluated-data-collection",
          attributes: {title: "Adults and Education"},
          relationships: {
            "data-points" => {
              data: [
                {
                  id: "36692321", type: "evaluated-data-point",
                  attributes: {title: "Total Population", modifier: "total", aggregator: "sum_and_moe", value: 10543.0, margin: 270.98}
                },
                {
                  id: "885493904", type: "evaluated-data-point",
                  attributes: {title: "Adults with Bachelor's Degree or Higher", modifier: "total", aggregator: "sum_and_moe", value: 6023.0, margin: 499.33}
                }
              ]
            }
          }
        }
      ]
    }
  end


end
