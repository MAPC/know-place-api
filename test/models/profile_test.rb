require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  def profile
    report = Report.new(title: "Demographics")
    place  = Place.new(name: "Dudley")
    @profile ||= Profile.new
    @profile.report = report
    @profile.place = place
    @profile
  end

  def test_valid
    assert profile.valid?
  end

  def test_complete
    assert_equal true, profile.complete?
  end

  def test_incomplete
    assert Profile.new.incomplete?
    assert Profile.new(place: Place.new).incomplete?
    assert Profile.new(report: Report.new).incomplete?
  end

  def test_title
    assert_equal "Demographics in Dudley", profile.title
  end
end
