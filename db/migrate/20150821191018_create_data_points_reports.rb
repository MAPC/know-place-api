class CreateDataPointsReports < ActiveRecord::Migration
  def change
    create_table :data_points_reports do |t|
      t.belongs_to :data_point, index: true
      t.belongs_to :report,    index: true
    end
  end
end
