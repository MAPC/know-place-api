class AddEvaluatedEtcToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :evaluation,   :json
    add_column :profiles, :evaluated_at, :datetime
  end
end
