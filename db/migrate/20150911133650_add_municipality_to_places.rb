class AddMunicipalityToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :municipality, :string
  end
end
