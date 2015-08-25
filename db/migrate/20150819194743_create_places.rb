class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.string :description
      t.json :geometry
      t.json :tags
      # t.belongs_to :users,  index: true, foreign_key: true
      # t.belongs_to :places, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
