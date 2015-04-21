class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :name
      t.text :photo
      t.text :phone
      t.text :role
      t.datetime :active_until
      t.text :stripe_customer_id
      t.text :provider
      t.text :uid

      t.timestamps null: false
    end
  end
end
