class CreateDataCollectionsReports < ActiveRecord::Migration
  def change
    create_table :data_collections_reports do |t|
      t.belongs_to :data_collection, index: true
      t.belongs_to :report,          index: true
    end
  end
end
