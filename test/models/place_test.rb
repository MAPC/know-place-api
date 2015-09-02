require "test_helper"

class PlaceTest < ActiveSupport::TestCase
  def place
    attributes = places(:dudley).attributes
    attributes.delete("id")
    @place ||= Place.new( attributes )
  end

  def test_valid
    assert place.valid?, "#{place.errors.full_messages}\n\n#{place.inspect}"
  end

  def test_requires_geometry
    pl = place.dup
    pl.geometry = nil
    assert_not pl.valid?
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

  def test_coordinate_count_no_error_when_empty
    place.geometry = nil
    assert_nothing_raised { place.valid? }
  end

  def test_prevents_too_long_geojson
    pl = place.dup
    pl.geometry = places(:invalid).geometry
    assert_not pl.valid?
  end

  def test_invalid_when_too_short_geojson
    pl = place.dup
    pl.geometry = {"type"=>"Polygon", "coordinates"=>[[]]}
    assert_not pl.valid?
  end

  def test_invalid_when_weird_geojson
    pl = place.dup
    pl.geometry = {"type"=>"Polygon", "coordinates"=>[]}
    assert_not pl.valid?
  end

  def test_not_too_big_an_area
    pl = place.dup
    pl.geometry = {"type"=>"Polygon","coordinates"=>[[[-71.00, 42.00],[-73.00, 42.00],[-73.00, 43.00],[-71.00, 43.00],[-71.00, 42.00]]]}
    assert_not pl.valid?, "Area: #{pl.area}"
  end

  # def test_must_be_simple
  #   skip "Surprised that this isn't simple."
  #   pl = place.dup
  #   pl.geometry = {"type"=>"Polygon","coordinates"=>[[[-77.0,35.1],[-77.4,35.3],[-77.0,35],[-77.1,35.1],[-77.2,35.1],[-77.2,35.3],[-77.1,35.1],[-77.0,35.1]]]}
  #   assert pl.valid?, pl.errors.full_messages
  # end

  def test_must_be_a_polygon
    pl = place.dup
    pl.geometry = {"type"=>"LineString","coordinates"=>[[-101.744384765625,39.32155002466662],[-100.9149169921875,39.24501680713314],[-97.635498046875,38.87392853923629]]}
    assert_not pl.valid?, pl.errors.full_messages
  end

  def test_invalid_when_too_many_geoids
    # TODO make geoids unique
    place.save
    place.geoids = (0..101).to_a.collect { 'GEOIDUS202LOL' }
    assert_not place.valid?, place.errors.full_messages
  end

  def test_invalid_when_not_enough_geoids
    place.save
    place.geoids = []
    assert_not place.valid?, place.errors.full_messages
  end

  def test_default_incomplete
    p = Place.new
    assert_not p.completed?
    assert_not p.complete?
    assert_not p.complete
    assert p.incomplete?
  end

  def test_complete
    p = Place.new(completed: true)
    assert p.completed?
    assert p.complete?
    assert p.complete
    assert_not p.incomplete?
  end

  def test_underlying_geometries
    assert_respond_to place, :underlying_geometries
    assert_respond_to place, :ugeo
  end

  def test_geoids
    assert_respond_to place, :geoids
  end

  def test_geometry_query
    expected_query = "
      SELECT row_to_json(fc)
        FROM ( SELECT 'FeatureCollection' AS type, array_to_json(array_agg(f)) AS features
          FROM ( SELECT 'Feature' AS type
            , ST_AsGeoJSON(ct.geom)::json AS geometry
            , row_to_json(
                (SELECT l FROM (SELECT id, geoid10) AS l)
              ) AS properties
            FROM census_tracts_2010 AS ct WHERE ST_Intersects(ST_SetSRID(geom,4326),ST_SetSRID(ST_GeomFromGeoJSON('#{ place.geometry.to_json }'), 4326))
          ) AS f
        ) AS fc;
    "
    assert_equal expected_query, place.geometry_query.to_sql
  end

  def test_saves_underlying_geometries
    p = place.dup
    p.save
    assert p.reload.underlying_geometries
  end

  def test_underlying_geometries_without_geometry
    p = place.dup
    p.geometry = nil
    assert_not p.valid?
    assert_not p.ugeo
  end

  def test_saves_geoids
    p = place.dup
    p.save
    assert p.reload.geoids, "Turns out it's empty: #{p.geoids.inspect}, but should have been #{ JSON.parse( p.geometry_query.execute.first['row_to_json'] )['features'].collect{|f| f['properties']['geoid10']} }"
  end




end
