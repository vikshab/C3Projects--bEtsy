class ChangeCardFormatInOrders < ActiveRecord::Migration
  def up
    change_column :orders, :buyer_card_short, :string
  end

  def down
    change_column :orders, :buyer_card_short, :integer
  end
end
