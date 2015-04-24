class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :account_id
      t.text :name
      t.text :email
      t.datetime :birthday
      t.text :gender
      t.text :photo
      

      t.timestamps null: false
    end
  end
end
