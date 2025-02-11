class AddUsersNameIndex < ActiveRecord::Migration[8.0]
  def change
    add_index :users, :name, unique: true
  end
end
