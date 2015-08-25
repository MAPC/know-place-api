require "test_helper"

class ReportTest < ActiveSupport::TestCase
  def report
    @report ||= reports(:tod)
  end

  def test_valid
    assert report.valid?
  end

  def test_requires_a_title
    report.title = ""
    assert_not report.valid?
  end

  def test_requires_a_title_of_certain_length
    report.title = "a" * 71
    assert_not report.valid?
    report.title = "a" * 6
    assert_not report.valid?
  end

  def test_requires_a_description
    report.description = ""
    assert_not report.valid?
  end

  def test_requires_a_description_of_certain_length
    report.description = "a" * 19
    assert_not report.valid?
    report.description = "a" * 141
    assert_not report.valid?
  end

  def test_tags_are_array
    assert_not_empty report.tags, report.tags.inspect
    assert Array, report.tags.class
  end

  def test_can_include_data_points_and_collections
    assert_respond_to report, :data_points
    assert_respond_to report, :data_collections
    assert_collection_proxy "DataPoint", report.data_points
    assert_collection_proxy "DataCollection", report.data_collections
  end
end
