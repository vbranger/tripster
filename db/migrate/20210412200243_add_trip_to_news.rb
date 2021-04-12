class AddTripToNews < ActiveRecord::Migration[6.1]
  def change
    add_reference :news, :trip, index: true
  end
end
