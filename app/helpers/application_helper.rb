module ApplicationHelper
  def display_dollars(cents)
    number_to_currency(cents/100.00)
  end

  def cart_display_text
    order_count = OrderItem.where(order_id: session[:order_id]).count
    display_text = "Cart (#{ order_count })"

    return display_text
  end

  def product_short_description(product)
    product.description[0..150] + '...'
  end
end
