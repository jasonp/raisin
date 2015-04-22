class CreateAccountsUsersTable < ActiveRecord::Migration
  def change
    create_table :accounts_users, id: false do |t|
      t.integer :account_id
      t.integer :user_id
    end
    
    add_index :accounts_users, :account_id
    add_index :accounts_users, :user_id
  end
end
