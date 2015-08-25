class DataCollection < ActiveRecord::Base

  has_and_belongs_to_many :data_points
  has_and_belongs_to_many :reports

  validates :title, presence: true, length: {
    minimum: 4, maximum: 70
  }
end
