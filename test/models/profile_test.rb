require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  def profile
    @profile ||= Profile.new
    @profile.report = reports(:demo)
    @profile.place = places(:dudley)
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
    assert_equal "Demographics Overview in Dudley Square", profile.title
  end

  def test_save_evaluates
    p = profile.dup
    assert_not profile.evaluated?
    p.save
    assert p.evaluated?, p.inspect
  end

  def test_save_without_report_does_not_evaluate
    p = profile.dup
    p.report = nil
    assert p.incomplete?
    assert_not p.evaluated?
    p.save
    assert p.not_yet_evaluated?, p.inspect
  end

  def test_save_without_place_does_not_evaluate
    p = profile.dup
    p.place = nil
    assert p.incomplete?
    assert_not p.evaluated?
    p.save
    assert p.not_yet_evaluated?, p.inspect
  end

  def test_evaluatable
    assert profile.not_yet_evaluated?
    assert_not profile.evaluated?
    profile.evaluate!
    assert profile.evaluated?
  end
end
