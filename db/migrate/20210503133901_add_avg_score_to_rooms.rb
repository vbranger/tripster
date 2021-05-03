class AddAvgScoreToRooms < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :avg_score, :float
  end
end
