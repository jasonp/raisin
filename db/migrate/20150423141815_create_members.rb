class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :account_id
      t.string :name
      t.datetime :birthday
      t.text :gender
      

      t.timestamps null: false
    end
  end
end
