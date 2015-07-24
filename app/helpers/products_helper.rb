module ProductsHelper
  def retire_product_text(product)
    "#{ product.retired ? "Reactivate" : "Retire" }"
  end

  def retire_text_short(product)
    "#{ product.retired ? "Reactivate" : "Retire" }"
  end

  def quantity_sold(product)
    quantities = product.order_items.select { |item| item.order.status == "paid" }
    quantities = quantities.map { |item| item.quantity_ordered }
    total = quantities.reduce(0) { |sum, current_quantity| sum += current_quantity }
  end
end
