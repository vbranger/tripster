class AddObjectToNews < ActiveRecord::Migration[6.1]
  def change
    add_reference :news, :imageable, polymorphic: true, index: true
  end
end
