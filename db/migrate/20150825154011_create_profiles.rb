class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :place,  index: true, foreign_key: true
      t.references :report, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
