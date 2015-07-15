class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.text :description
      t.integer :product_id

      t.timestamps null: false
    end
  end
end
