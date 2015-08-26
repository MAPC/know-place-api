class DataSource < ActiveRecord::Base

  has_many :fields, dependent: :nullify

  validates :database_url, presence: true
  validate :parseable_uri

  private

  def parseable_uri
    URI.parse(database_url).present?
  rescue
    errors.add(:database_url, "must be a valid URL")
  end

end
