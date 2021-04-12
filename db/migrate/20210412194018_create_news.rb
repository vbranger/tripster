class CreateNews < ActiveRecord::Migration[6.1]
  def change
    create_table :news do |t|
      t.references :user, null: false, foreign_key: true
      t.string :action_type
      t.string :content

      t.timestamps
    end
  end
end
