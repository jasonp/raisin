class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :creator_id
      t.text :notification
      t.string :email_status
      t.string :status
      t.integer :item_id
      t.integer :list_id
      t.integer :project_id

      t.timestamps null: false
    end
  end
end
