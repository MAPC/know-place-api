class Place < ActiveRecord::Base
  include PgSearch

  # Ensure we grab only the geometry, even when passed a Feature.
  before_validation :shift_geometry
  before_validation :uniq_geoids

  # Either use the GeoIDs given in the update, or query
  # the spatial database for the GeoIDs of intersecting
  # underlying geometries, and store those.
  before_save :get_underlying_geometries

  has_many :profiles, dependent: :nullify
  belongs_to :user
  # belongs_to :creator,  class_name: "User"
  # belongs_to :based_on, class_name: "Place"

  def self.complete
    where(completed: true)
  end

  pg_search_scope(
    :search,
    against: {
      name:        'A',
      tags:        'B',
      description: 'C'
    },
    using: { tsearch: {
      dictionary: "english",
      prefix: true
    } }
  )

  validates :geometry, presence: true
  validates :name, presence: true, length: {
    minimum: 5, maximum: 70
  }, if: :complete?
  validates :description, presence: true, length: {
    minimum: 10, maximum: 140
  }, if: :complete?
  validates :underlying_geometries, presence: true,
    on: :update
  validates :geoids, presence: true, length:
    { minimum: 1, maximum: 100, message: "must be between 1 and 100 geoids, was %{value}" },
    on: :update
  # TODO validates :tags -> array, some other things

  # Does this really take care of all the following validations?
  # TODO Reassess tests to make sure these cases are all really
  # covered.
  validate :valid_area?
  # validate :valid_geojson?
  # validate :valid_coordinate_count?
  # validate :valid_polygon?
  # validate :valid_geoids

  VALID_AREA = 1.0
  alias_attribute :title, :name

  # TODO: Require all query objects when autoloading.
  def area
    res = ::AreaQuery.new( geometry.to_json ).execute
    res ? res.first['st_area'].to_f : 0
  end

  alias_attribute :complete,   :completed
  alias_attribute :complete?,  :completed
  alias_attribute :completed?, :completed

  def incomplete?
    !complete?
  end

  alias_attribute :underlying, :underlying_geometries
  alias_attribute :ugeo,       :underlying_geometries

  # TODO: Require all query objects when autoloading.
  def geometry_query
    ::UnderlyingGeometryQuery.new( geometry.to_json )
  end

  private

  def valid_area?
    if area > VALID_AREA || area == 0
      errors.add(:geometry, "area must be > 0 and <= #{VALID_AREA}, but was #{area}")
    end
  rescue PG::InternalError => e
    errors.add :geometry, e.message
  end

  # TODO: What are the cases in which this is needed?
  # Oh, this is included when we call it above.
  def shift_geometry
    if geometry && geometry.has_key?("geometry")
      Rails.logger.debug "Shifted geometry on #{self.id}"
      assign_attributes geometry: geometry["geometry"]
    end
  end

  # TODO: Do we need to write-in-place with the `!`?
  def uniq_geoids
    Array(geoids).uniq!
  end

  # Refactor into a service object or something else.
  def get_underlying_geometries
    begin
      ugeo = JSON.parse geometry_query.execute.first['row_to_json']
      geoids = ugeo['features'].collect{|feature|
        feature['properties']['geoid']
      }.uniq
      self.assign_attributes underlying_geometries: ugeo, geoids: geoids
    rescue StandardError => e
      errors.add :geometry, "could not get underlying geometries because\n#{e}"
    ensure
      # NOOP
      # TODO: Is this ensure clause necessary?
    end
  end

end
