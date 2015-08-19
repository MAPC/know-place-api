class CreateDataSources < ActiveRecord::Migration
  def change
    create_table :data_sources do |t|
      t.string :database_url, null: false

      t.timestamps null: false
    end
  end
end
