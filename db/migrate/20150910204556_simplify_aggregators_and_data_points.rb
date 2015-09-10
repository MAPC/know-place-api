class SimplifyAggregatorsAndDataPoints < ActiveRecord::Migration
  def change
    remove_column :data_points, :field_mapping, :json
    add_column    :data_points, :fields, :string
    add_column    :data_points, :tables, :string

    remove_column :aggregators, :return_type, :string
    remove_column :aggregators, :parameters,  :string
  end
end
