class ChangePhotoUrlType < ActiveRecord::Migration[6.1]
  def change
    change_column :trips, :photo_url, :text
  end
end
