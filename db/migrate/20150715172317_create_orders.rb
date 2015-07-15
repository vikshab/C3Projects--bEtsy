class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :status
      t.string :buyer_name
      t.string :buyer_email
      t.text :buyer_address
      t.integer :buyer_card_short
      t.datetime :buyer_card_expiration

      t.timestamps null: false
    end
  end
end
