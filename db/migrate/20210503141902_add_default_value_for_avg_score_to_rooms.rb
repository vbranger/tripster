class AddDefaultValueForAvgScoreToRooms < ActiveRecord::Migration[6.1]
  def change
    change_column :rooms, :avg_score, :float, :default => 0.0
  end
end
