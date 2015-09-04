class AreaQuery

  def initialize(geojson)
    @geojson = geojson
  end

  def execute
    begin
      GeographicDatabase.connection.execute to_sql
    rescue
      # NO OP
    ensure
      # NO OP
    end
  end

  def to_sql
    "
      SELECT ST_Area(
        ST_SetSRID(
          ST_GeomFromGeoJSON('#{ @geojson }'),
          4326
        )
      )
    "
  end
end