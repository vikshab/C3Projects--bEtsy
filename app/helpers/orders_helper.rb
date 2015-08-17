module OrdersHelper

  def item_total(order)
    items = OrderItem.where("order_id = ?", order.id).pluck(:quantity)
    @total_quantity = items.sum
  end

  def out_of_stock
    @order_items.any? { |order_item| order_item.quantity > order_item.product.stock } |
  end
end
