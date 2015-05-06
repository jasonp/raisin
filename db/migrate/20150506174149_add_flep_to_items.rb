class AddFlepToItems < ActiveRecord::Migration
  def change
    add_column :items, :flep, :string
  end
end
