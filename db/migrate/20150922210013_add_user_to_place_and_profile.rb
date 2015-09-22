class AddUserToPlaceAndProfile < ActiveRecord::Migration
  def change
    add_reference :places,   :user, index: true, foreign_key: true
    add_reference :profiles, :user, index: true, foreign_key: true
  end
end
