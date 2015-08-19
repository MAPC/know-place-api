class Field < ActiveRecord::Base
  belongs_to :data_source

  validates :column_name, presence: true, length: {
    minimum: 1, maximum: 255
  }
  validates :data_source_id, presence: true
end
