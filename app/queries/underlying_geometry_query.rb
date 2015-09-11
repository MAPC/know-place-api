class UnderlyingGeometryQuery

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
      SELECT row_to_json(fc)
        FROM ( SELECT 'FeatureCollection' AS type, array_to_json(array_agg(f)) AS features
          FROM ( SELECT 'Feature' AS type
            , ST_AsGeoJSON(subquery.geom)::json AS geometry
            , row_to_json(
                (SELECT l FROM (SELECT id, geoid10) AS l)
              ) AS properties

            FROM (
              SELECT
                ct.id,
                ct.geom,
                ct.geoid10,
                ST_Area(ST_SetSRID(geom,4326)) as d,
                ST_Area(
                  ST_Intersection(
                    ST_SetSRID( ST_GeomFromGeoJSON('#{ @geojson }'), 4326),
                    ST_SetSRID(geom,4326)
                  )
                ) as n
              FROM census_tracts_2010 AS ct
              WHERE
                ST_Intersects(
                  ST_SetSRID(geom,4326),
                  ST_SetSRID( ST_GeomFromGeoJSON('#{ @geojson }'), 4326)
                )
            ) subquery
            WHERE (n/d*100) >= 15


          ) AS f
        ) AS fc;
    "
  end
end