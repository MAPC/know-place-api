class Aggregator < ActiveRecord::Base
  has_many :data_points

  validates :name, presence: true, length: {
    minimum: 3, maximum: 140
  }
end
