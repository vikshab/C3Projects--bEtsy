class ChangeColumnDefaultsForProductsAndOrders < ActiveRecord::Migration
  def change
    change_column_default :products, :stock, 0
    change_column_default :orders, :status, "pending" 
  end
end
