module ProductsHelper
  def retire_product_text(product)
    "#{ product.retired ? "Reactivate" : "Retire" } this Product"
  end

  def retire_text_short(product)
    "#{ product.retired ? "Reactivate" : "Retire" }"
  end

  def display_categories(product)
    categories = product.categories.map { |category| category.name }
    categories = categories.join(", ")
  end

  def quantity_sold(product)
    quantities = product.order_items.map { |item| item.quantity_ordered }
    total = quantities.reduce(0) { |sum, current_quantity| sum += current_quantity }
  end
end
