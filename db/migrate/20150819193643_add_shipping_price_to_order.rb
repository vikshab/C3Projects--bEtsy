class AddShippingPriceToOrder < ActiveRecord::Migration
  def change
    add_column :order, :shipping_price, :integer
  end
end
