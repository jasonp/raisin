class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.text :title
      t.integer :list_id
      t.integer :user_id
      t.datetime :due
      t.text :status
      t.integer :created_by
      t.integer :completed_by

      t.timestamps null: false
    end
  end
end
