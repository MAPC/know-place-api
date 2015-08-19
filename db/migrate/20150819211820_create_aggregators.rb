class CreateAggregators < ActiveRecord::Migration
  def change
    create_table :aggregators do |t|
      t.string :name
      t.string :description
      t.string :modifier
      t.string :operation

      t.timestamps null: false
    end
  end
end
