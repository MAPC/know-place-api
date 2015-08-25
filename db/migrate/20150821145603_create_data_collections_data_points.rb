class CreateDataCollectionsDataPoints < ActiveRecord::Migration
  def change
    create_table :data_collections_points do |t|
      t.belongs_to :data_point,      index: true
      t.belongs_to :data_collection, index: true
    end
  end
end
