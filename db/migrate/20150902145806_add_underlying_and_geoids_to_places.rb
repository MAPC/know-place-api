class AddUnderlyingAndGeoidsToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :underlying_geometries, :json
    add_column :places, :geoids, :text, array: true
  end
end
