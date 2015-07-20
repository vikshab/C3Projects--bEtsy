class OrderItem < ActiveRecord::Base
  before_save :product_has_stock?
  before_create :product_absent_from_order? # we want false if the product is present

  # DB relationships
  belongs_to :order
  belongs_to :product


  # data validations
  validates :product_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :order_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :quantity_ordered, presence: true, numericality: { only_integer: true, greater_than: 0 }


  # this should probably be in helpers/order_items_helpers
  # if this is only going to be used in the cart, maybe just use it inline inside the view
  def remove_prompt_text
    "Are you sure you want to remove this item (#{ product.name }) from your cart?"
  end

  # group: note that we need to talk about this more

  # fyi, leaving these comments here in case future me is not articulate.
  # I'm always more interested in doing what other people understand better!
  # we should do what's best for our group understanding. n_n --Jeri

  # THE QUESTION AT HAND: why does price alone make the most sense to me?
  # because of how you call it inline: OrderItem.price.
  # to me, *OrderItem.price* says: what's the price of this item?
  # it does not say to me: what's the price of the things that make up this item.
  # if my item is a six-pack of beer, I expect to see the price for the whole six-pack.
  def item_price # v. price / cost / item_cost / total_item_price / total_item_cost / etc
    quantity_ordered * product.price
  end

  def product_has_stock? # !Q is this the right way to do this?
    # stock = product.has_available_stock?
    unless product.has_available_stock?
      errors.add(:quantity_ordered, "Product must have available stock.")
      return false
    end

    return true
  end

  def product_absent_from_order?
    order.order_items.each do |item|
      if item.product_id == product_id
        errors.add(:product_id, "That product is already part of this order.")
        return false
      end
    end

    return true
  end
end
