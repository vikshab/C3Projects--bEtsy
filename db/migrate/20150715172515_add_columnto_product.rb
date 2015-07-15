class AddColumntoProduct < ActiveRecord::Migration
  def change
    add_column :products, :retired, :string, default: "no"
  end
end
