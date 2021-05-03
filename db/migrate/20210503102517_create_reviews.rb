class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.text :content
      t.integer :score
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
