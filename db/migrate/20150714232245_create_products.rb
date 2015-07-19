class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.float :price
      t.text :desc
      t.integer :stock
      t.string :photo_url
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
