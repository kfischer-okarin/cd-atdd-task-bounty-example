class CreateBounties < ActiveRecord::Migration[8.0]
  def change
    create_table :bounties do |t|
      t.string :title, null: false
      t.integer :reward, null: false
      t.references :posted_by, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
