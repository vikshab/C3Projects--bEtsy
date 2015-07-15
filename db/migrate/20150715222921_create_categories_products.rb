class CreateCategoriesProducts < ActiveRecord::Migration
  def change
    create_table :categories_products, id: false do |t|
      t.belongs_to :product, index: true, null: false
      t.belongs_to :category, index: true, null: false
    end
  end
end
