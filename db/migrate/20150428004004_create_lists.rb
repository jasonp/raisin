class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.text :title
      t.text :status
      t.integer :project_id

      t.timestamps null: false
    end
  end
end
