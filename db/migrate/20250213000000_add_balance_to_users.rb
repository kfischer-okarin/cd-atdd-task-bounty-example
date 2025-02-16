class AddBalanceToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :balance, :integer, default: 0, null: false
  end
end
