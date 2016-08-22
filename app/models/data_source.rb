class DataSource < ActiveRecord::Base

  has_many :fields, dependent: :nullify

  validates :database_url, presence: true
  validate :parseable_uri

  private

  def parseable_uri
    # TODO: Do we need to check presence if it
    # throws an error when parsing a bad URI?
    URI.parse(database_url).present?
  rescue
    errors.add(:database_url, "must be a valid URL")
  end

end
