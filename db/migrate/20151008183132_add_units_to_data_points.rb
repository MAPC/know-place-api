class AddUnitsToDataPoints < ActiveRecord::Migration
  def change
    add_column :data_points, :units, :string
  end
end
