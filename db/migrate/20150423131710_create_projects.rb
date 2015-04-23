class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.text :title
      t.string :removeable
      t.text :description
      t.integer :account_id
      t.text :status

      t.timestamps null: false
    end
  end
end
