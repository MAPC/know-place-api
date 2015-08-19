class Place < ActiveRecord::Base
  # belongs_to :creator,  class_name: "User"
  # belongs_to :based_on, class_name: "Place"
  validate :valid_geojson
  validates :name, presence: true, length: {
    minimum: 5, maximum: 70
  }
  validates :description, presence: true, length: {
    minimum: 10, maximum: 140
  }

  private

  def valid_geojson
    if RGeo::GeoJSON.decode(geometry, json_parser: :json).nil?
      errors.add(:geometry, "must be valid GeoJSON")
    end
  end

  def parseable_uri
    URI.parse(database_url).present?
  rescue
    errors.add(:database_url, "must be a valid URL")
  end
end
