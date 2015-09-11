class AddDataPointToTopics < ActiveRecord::Migration
  def change
    add_reference :data_points, :topic, index: true, foreign_key: true
  end
end
