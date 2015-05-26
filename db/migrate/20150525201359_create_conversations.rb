class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.text :title
      t.text :content
      t.integer :user_id
      t.integer :project_id
      t.string :status

      t.timestamps null: false
    end
  end
end
