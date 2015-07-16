class CreateProductsCategories < ActiveRecord::Migration
  def change
    create_table :products_categories, id: false do |t|
      t.belongs_to :products, index: true, null: false
      t.belongs_to :categories, index: true, null: false
    end
  end
end
