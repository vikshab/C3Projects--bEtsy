module ProductsHelper
  def retire_product_text(product)
    "#{ product.retired ? "Reactivate" : "Retire" } this Product"
  end

  def retire_text_short(product) # TODO: spec
    "#{ product.retired ? "Reactivate" : "Retire" }"
  end

  def quantity_sold(product) # TODO: spec
    quantities = product.order_items.map { |item| item.quantity_ordered }
    total = quantities.reduce(0) { |sum, current_quantity| sum += current_quantity }
  end
end
