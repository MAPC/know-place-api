class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :title
      t.string :description
      t.boolean :official
      t.json :tags

      t.timestamps null: false
    end
  end
end
