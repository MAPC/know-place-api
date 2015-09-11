class ChangeAggregatorOperations < ActiveRecord::Migration
  def change
    rename_column :aggregators, :operation, :definition
    add_column    :aggregators, :drop_statement, :string
  end
end
