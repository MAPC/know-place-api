class Report < ActiveRecord::Base

  has_and_belongs_to_many :data_points
  has_and_belongs_to_many :data_collections

  validates :title, presence: true, length: {
    minimum: 7, maximum: 70
  }
  validates :description, presence: true, length: {
    minimum: 20, maximum: 140
  }
end