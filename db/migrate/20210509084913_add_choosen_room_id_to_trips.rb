class AddChoosenRoomIdToTrips < ActiveRecord::Migration[6.1]
  def change
    add_column :trips, :choosen_room_ids, :integer, array: true, default: []
  end
end
