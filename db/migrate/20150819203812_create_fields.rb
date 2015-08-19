class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.references :data_source, index: true, foreign_key: true
      t.string :column_name

      t.timestamps null: false
    end
  end
end
