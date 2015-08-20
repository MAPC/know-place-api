class CreateDataPointsFields < ActiveRecord::Migration
  def change
    create_table :data_points_fields do |t|
      t.belongs_to :data_point, index: true
      t.belongs_to :field, index: true
    end
  end
end