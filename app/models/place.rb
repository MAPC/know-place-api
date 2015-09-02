class Place < ActiveRecord::Base

  # Either use the GeoIDs given in the update, or query
  # the spatial database for the GeoIDs of intersecting
  # underlying geometries, and store those.
  # before_validate :use_or_find_geoids # TODO
  before_validation :shift_geometry
  before_save :get_underlying_geometries

  def shift_geometry
    if geometry && geometry.has_key?("geometry")
      assign_attributes(geometry: geometry["geometry"])
    end
  end

  has_many :profiles, dependent: :nullify
  # belongs_to :creator,  class_name: "User"
  # belongs_to :based_on, class_name: "Place"

  def self.complete
    where(completed: true)
  end

  # TODO: Add a Complete flag, an underlying_geometries field,
  # and a geoids method which stores geoids or grabs them on the fly
  # from the underlying_geometries field

  # Also, set a before_save hook to look up the intersecting
  # geometries before persisting.

  # TODO: Only validate some of these if it's marked as complete

  validates :name, presence: true, length: {
    minimum: 5, maximum: 70
  }, if: :complete?
  validates :description, presence: true, length: {
    minimum: 10, maximum: 140
  }, if: :complete?
  validates :geometry, presence: true
  validates :underlying_geometries, presence: true, on: :update
  validates :geoids, presence: true, length: { minimum: 1, maximum: 100 }, on: :update
  # TODO validates :tags -> array, some other things

  validate :valid_geojson?
  validate :valid_coordinate_count?
  validate :valid_polygon?
  validate :valid_area?
  # validate :valid_geoids # TODO

  VALID_AREA = 1.0
  alias_attribute :title, :name


  def area
    if parsed_geojson && parsed_geojson.geometry_type == RGeo::Feature::Polygon
      parsed_geojson.area
    else
      0
    end
  end

  def coordinate_count
    # TODO I'm clunky and there are dependencies in me. Refactor me.
    return 0 if !geometry
    coords = geometry.fetch('coordinates', [[]]).first
    # Handles a weird case when geometry.coordinates = []
    coords.present? ? coords.count : 0
  end

  alias_attribute :complete,   :completed
  alias_attribute :complete?,  :completed
  alias_attribute :completed?, :completed

  def incomplete?
    !complete?
  end

  alias_attribute :underlying, :underlying_geometries
  alias_attribute :ugeo, :underlying_geometries

  def geometry_query
    ::UnderlyingGeometryQuery.new( geometry.to_json )
  end

  private

  def get_underlying_geometries
    unless parsed_geojson.nil?
      begin
        ugeo = JSON.parse( geometry_query.execute.first['row_to_json'] )
        geoids = ugeo['features'].collect{|feature|
          feature['properties']['geoid10']
        }.uniq
        self.assign_attributes(underlying_geometries: ugeo)
        self.assign_attributes(geoids: geoids)
      rescue
        # NOOP
      ensure
        # NOOP
      end
    end
  end

  # def geojson_property_map(geojson:, property:)
  # end

  def parsed_geojson
    # Should be able to accept either a GeoJSON Feature or a Polygon
    @parsed ||= RGeo::GeoJSON.decode(geometry.to_json, json_parser: :json)
  end

  def valid_geojson?
    if parsed_geojson.nil?
      errors.add(:geometry, "must be valid GeoJSON, but was #{geometry.inspect}")
    end
  end

  def valid_polygon?
    type = parsed_geojson.try(:geometry_type)
    if type != RGeo::Feature::Polygon
      errors.add(:geometry, "must be a polygon, but was type #{type}")
    end
  end

  def valid_area?
    if area > VALID_AREA
      errors.add(:geometry, "must be <= #{VALID_AREA}, but was #{area}")
    end
  end

  def valid_coordinate_count?
    if coordinate_count < 4
      errors.add(:geometry, "must have enough points to make a polygon (4)")
    elsif coordinate_count > 100
      errors.add(:geometry, "must have fewer than 100 points")
    end
  end

    # def valid_geoids? # TODO
  #   ct = geoids.count
  #   if ct == 0 || ct > 100
  #     errors.add(:geometry, "Too many intersecting geometries. Should be between 1 - 100, but was #{ct}")
  #   end
  # end

  # def simple_geojson
  # end


end
