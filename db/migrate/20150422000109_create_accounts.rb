class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.text :name
      t.text :stripe_customer_id
      t.datetime :active_until
      t.text :plan

      t.timestamps null: false
    end
  end
end
