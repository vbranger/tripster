class RenameUserGroupToTrips < ActiveRecord::Migration[6.1]
  def change
    rename_column :invites, :user_group_id, :trip_id
  end
end
