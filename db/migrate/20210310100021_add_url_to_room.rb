class AddUrlToRoom < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :url, :string
  end
end
