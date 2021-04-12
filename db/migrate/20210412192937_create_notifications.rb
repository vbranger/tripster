class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :action_type
      t.string :content
      t.references :imageable, polymorphic: true
      t.timestamps
    end
  end
end
