require "test_helper"

class PlaceTest < ActiveSupport::TestCase
  def place
    @place ||= places(:dudley)
  end

  def test_valid
    assert place.valid?
  end

  def test_rejects_invalid_geojson
    invalid_geojson = '{"geometry": {"type": "Polygon","coordinates": [[[-70.85,42.23],[-70.84,42.26],[-70.78,42.22],[-70.84,42.21],[-70.85,42.23]]]}}'
    new_place = Place.new(geometry: invalid_geojson)
    assert_not new_place.valid?
  end

  def test_requires_name
    place.name = ""
    assert_not place.valid?
  end

  def test_requires_name_to_not_be_too_long
    place.name = "X" * 71
    assert_not place.valid?
  end

  def test_requires_name_of_certain_length
    place.name = "X" * 4
    assert_not place.valid?
  end

  def test_requires_description_of_certain_length
    place.description = "X" * 9
    assert_not place.valid?
    place.description = "X" * 141
    assert_not place.valid?
  end
end
