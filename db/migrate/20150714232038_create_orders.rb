class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :status
      # t.string :buyer_name
      # t.string :buyer_email
      # t.string :buyer_address
      # t.string :buyer_state
      # t.string :buyer_city
      # t.integer :buyer_zip
      # t.integer :buyer_last4cc
      # t.string :buyer_expcc

      t.timestamps null: false
    end
  end
end
