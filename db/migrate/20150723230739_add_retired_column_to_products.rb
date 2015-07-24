class AddRetiredColumnToProducts < ActiveRecord::Migration
  def change
    add_column :products, :retired, :boolean
    change_column_default :products, :retired, false
  end
end
