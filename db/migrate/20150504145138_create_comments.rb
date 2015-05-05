class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :user_id
      t.integer :item_id
      t.integer :list_id
      t.integer :file_id
      t.integer :conversation_id

      t.timestamps null: false
    end
  end
end
