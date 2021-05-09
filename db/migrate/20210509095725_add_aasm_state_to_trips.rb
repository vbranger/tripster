class AddAasmStateToTrips < ActiveRecord::Migration[6.1]
  def change
    add_column :trips, :aasm_state, :string
  end
end
