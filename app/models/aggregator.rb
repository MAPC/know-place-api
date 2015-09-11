class Aggregator < ActiveRecord::Base

  after_save :send_function_to_database_server

  # has_and_belongs_to_many :data_points
  has_many :data_points

  validates :name, presence: true, length: {
    minimum: 3, maximum: 140
  }
  # validates :definition, presence: true, length: {
  #   minimum: 10, maximum: 1000
  # }
  alias_attribute :operation, :definition

  private

    def send_function_to_database_server
      conn = GeographicDatabase.connection
      conn.execute drop_statement if drop_statement
      conn.execute definition     if definition
    end
end
