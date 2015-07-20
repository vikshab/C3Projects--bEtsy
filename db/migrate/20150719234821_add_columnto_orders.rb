class AddColumntoOrders < ActiveRecord::Migration
  def change
    add_column :orders, :subtotal, :decimal, precision: 12, scale: 2
    add_column :orders, :buyer_id, :integer
  end
end
