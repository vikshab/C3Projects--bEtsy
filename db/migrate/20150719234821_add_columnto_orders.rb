class AddColumntoOrders < ActiveRecord::Migration
  def change
    add_column :orders, :subtotal, :float
    add_column :orders, :buyer_id, :integer
  end
end
