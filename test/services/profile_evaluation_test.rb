require "test_helper"

class ProfileEvaluationTest < ActiveSupport::TestCase
  def setup
    Aggregator.find_each(&:save)
  end

  def evaluation
    profile = profiles(:dtod)
    profile.place.geoids = ['14000US25001010100']
    @ev ||= ProfileEvaluation.new(profile: profile)
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
    assert_equal expected_evaluated_profile, evaluation.perform
  end

  def expected_evaluated_profile
    {
      data: [
        {
          id: "36692321", type: "evaluated-data-point",
          attributes: {title: "Total Population", modifier: "total", aggregator: "sum_and_moe", value: 2616.0, margin: 134.0, units: "residents" }
        },
        {
          id: "885493904", type: "evaluated-data-point",
          attributes: {title: "Adults with Bachelor's Degree or Higher", modifier: "total", aggregator: "sum_and_moe", value: 1442.0, margin: 211.0, units: "degree holders" } # TODO double-check
        },
        {
          id: "274691428", type: "evaluated-data-collection",
          attributes: {title: "Adults and Education"},
          relationships: {
            "data-points" => {
              data: [
                {
                  id: "36692321", type: "evaluated-data-point",
                  attributes: {title: "Total Population", modifier: "total", aggregator: "sum_and_moe", value: 2616.0, margin: 134.0, units: "residents" }
                },
                {
                  id: "885493904", type: "evaluated-data-point",
                  attributes: {title: "Adults with Bachelor's Degree or Higher", modifier: "total", aggregator: "sum_and_moe", value: 1442.0, margin: 211.0, units: "degree holders"} # TODO double-check
                }
              ]
            }
          }
        }
      ]
    }
  end


end
