class CreateSeenUpdates < ActiveRecord::Migration
  def change
    create_table :seen_updates do |t|
      t.integer :user_id
      t.integer :post_id

      t.timestamps null: false
    end
  end
end
