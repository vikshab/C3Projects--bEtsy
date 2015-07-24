class AddStatusToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :status, :string, default: "pending", null: false
  end
end
