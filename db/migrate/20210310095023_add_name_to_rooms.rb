class AddNameToRooms < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :name, :string
    add_column :rooms, :price, :float
    add_column :rooms, :photo, :string
    add_column :rooms, :website, :string
    add_column :rooms, :web_id, :string
  end
end
