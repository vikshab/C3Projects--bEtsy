class ChangeColumnNullForAllTables < ActiveRecord::Migration
  def change
    change_column_null :categories, :name, false

    change_column_null :order_items, :product_id, false
    change_column_null :order_items, :order_id, false
    change_column_null :order_items, :quantity_ordered, false

    change_column_null :orders, :status, false

    change_column_null :products, :name, false
    change_column_null :products, :price, false
    change_column_null :products, :seller_id, false
    change_column_null :products, :stock, false

    change_column_null :reviews, :rating, false
    change_column_null :reviews, :product_id, false

    change_column_null :sellers, :username, false
    change_column_null :sellers, :email, false
    change_column_null :sellers, :password_digest, false
  end
end
