class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.text :title
      t.text :content
      t.integer :user_id
      t.string :status

      t.timestamps null: false
    end
  end
end
