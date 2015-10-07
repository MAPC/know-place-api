class RemoveSqlFromAggregators < ActiveRecord::Migration
  def change
    remove_column :aggregators, :before_fields,  :string
    remove_column :aggregators, :after_fields,   :string
    remove_column :aggregators, :drop_statement, :string
    remove_column :aggregators, :definition,     :string
  end
end