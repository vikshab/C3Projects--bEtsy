class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.integer :product_id
      t.integer :order_id
      t.integer :quantity_ordered

      t.timestamps null: false
    end
  end
end
