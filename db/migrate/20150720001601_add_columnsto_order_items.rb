class AddColumnstoOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :unit_price, :float
    add_column :order_items, :total_price, :float
    add_column :order_items, :status, :string
  end
end
