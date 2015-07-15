class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.integer :price
      t.integer :seller_id
      t.integer :stock
      t.text :description
      t.string :photo_url

      t.timestamps null: false
    end
  end
end
