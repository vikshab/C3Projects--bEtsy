class AddShippingToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :shipping_type, :string
    add_column :orders, :shipping_price, :integer, default: 0
    add_column :orders, :shipping_estimate, :datetime
  end
end
