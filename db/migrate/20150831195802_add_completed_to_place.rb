class AddCompletedToPlace < ActiveRecord::Migration
  def change
    add_column :places, :completed, :boolean, default: false
  end
end
