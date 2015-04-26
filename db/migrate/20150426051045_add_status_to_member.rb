class AddStatusToMember < ActiveRecord::Migration
  def change
    add_column :members, :status, :text
  end
end
