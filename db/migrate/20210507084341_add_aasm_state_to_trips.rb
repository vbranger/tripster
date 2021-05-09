class AddAasmStateToTrips < ActiveRecord::Migration[6.1]
  def change
    add_column :trips, :room_state, :string
  end
end
