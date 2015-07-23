module OrderItemsHelper
  def remove_prompt_text(order_item)
    "Are you sure you want to remove this item (#{ order_item.product.name }) from your cart?"
  end
end
