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

  alias_attribute :title, :name

  private

  def valid_geojson
    if RGeo::GeoJSON.decode(geometry.to_json, json_parser: :json).nil?
      errors.add(:geometry, "must be valid GeoJSON, but was #{geometry.inspect}")
    end
  end

  def parseable_uri
    URI.parse(database_url).present?
  rescue
    errors.add(:database_url, "must be a valid URL")
  end
end
