class RemoveUserIdFromOrderItems < ActiveRecord::Migration
  def change
    remove_column :order_items, :user_id, :integer
  end
end
