module ApplicationHelper
  def display_dollars(cents)
    number_to_currency(cents/100.00)
  end

  def cart_display_text
    display_text = "Cart"

    if session[:order_id] && Order.find_by(id: session[:order_id])
      no_items = OrderItem.where(order_id: session[:order_id]).count
      display_text += " (#{ no_items })" if no_items > 0
    end

    return display_text
  end

  def product_short_description(product)
    if product.description && product.description.length > 151
      return product.description[0..150] + '...'
    elsif product.description
      return product.description
    end
  end
end
