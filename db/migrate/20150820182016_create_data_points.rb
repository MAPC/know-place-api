class CreateDataPoints < ActiveRecord::Migration
  def change
    create_table :data_points do |t|
      t.string :name
      t.references :aggregator, index: true, foreign_key: true
      t.json :field_mapping

      t.timestamps null: false
    end
  end
end
