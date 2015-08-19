class AddShippingPriceToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :shipping_price, :integer
  end
end
