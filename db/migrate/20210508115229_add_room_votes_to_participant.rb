class AddRoomVotesToParticipant < ActiveRecord::Migration[6.1]
  def change
    add_column :participants, :room_votes, :integer, array: true, default: []
  end
end
