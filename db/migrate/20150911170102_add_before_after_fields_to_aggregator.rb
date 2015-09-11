class AddBeforeAfterFieldsToAggregator < ActiveRecord::Migration
  def change
    add_column :aggregators, :before_fields, :string
    add_column :aggregators, :after_fields,  :string
  end
end
