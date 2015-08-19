class Aggregator < ActiveRecord::Base

  has_and_belongs_to_many :fields

  validates :name, presence: true, length: {
    minimum: 3, maximum: 140
  }
  validates :operation, presence: true, length: {
    minimum: 10, maximum: 1000
  }
  validate :valid_syntax

  private

  def valid_syntax
    PgQuery.parse operation
  rescue PgQuery::ParseError
    errors.add :operation, """must be valid PostgreSQL syntax"""
  end

end
