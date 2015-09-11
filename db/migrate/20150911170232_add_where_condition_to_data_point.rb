class AddWhereConditionToDataPoint < ActiveRecord::Migration
  def change
    add_column :data_points, :where, :string
  end
end
