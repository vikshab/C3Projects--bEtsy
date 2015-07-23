class CreateBuyers < ActiveRecord::Migration
  def change
    create_table :buyers do |t|
      t.string :name
      t.string :email
      t.string :address
      t.string :city
      t.string :state
      t.integer :zip
      t.integer :credit_card
      t.integer :cvv
      t.string :exp
      t.references :order, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
