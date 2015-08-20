class Field < ActiveRecord::Base
  belongs_to :data_source

  has_and_belongs_to_many :data_points

  validates :column_name, presence: true, length: {
    minimum: 1, maximum: 255
  }
  validates :data_source_id, presence: true
end
