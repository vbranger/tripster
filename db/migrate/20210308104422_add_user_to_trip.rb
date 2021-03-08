class AddUserToTrip < ActiveRecord::Migration[6.1]
  def change
    add_reference :trips, :user, index: true
  end
end
