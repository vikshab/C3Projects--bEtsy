class ChangeCreditCardLimitforBuyer < ActiveRecord::Migration
  def change
    change_column :buyers, :credit_card, :integer, :limit => 8
  end
end
