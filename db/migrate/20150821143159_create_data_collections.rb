class CreateDataCollections < ActiveRecord::Migration
  def change
    create_table :data_collections do |t|
      t.string :title
      t.json :ordered_data_points

      t.timestamps null: false
    end
  end
end
