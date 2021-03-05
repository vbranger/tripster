class CreateTrips < ActiveRecord::Migration[6.1]
  def change
    create_table :trips do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.string :destination

      t.timestamps
    end
  end
end
