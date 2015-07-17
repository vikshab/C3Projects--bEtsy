class OrderItem < ActiveRecord::Base
  # DB relationships
  belongs_to :product
  belongs_to :order

  # data validations
  validates :product_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :order_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :quantity_ordered, presence: true, numericality: { only_integer: true, greater_than: 0 }
  # !R !W is there a way we can adjust this validation to check the product first?

  # scopes
  scope :by_product, ->(prod_id) { where(product_id: prod_id) }
  # this scope is unecessary, because product.order_items can be used.
  # order_items_controller's #more will need to be rewritten to use the right syntax & to not reinvent the wheel.

  # this should probably be in helpers/order_items_helpers
  # if this is only going to be used in the cart, maybe just use it inline inside the view
  def remove_prompt_text
    "Are you sure you want to remove this item (#{ quantity_ordered } #{ product.name }) from your cart?"
  end

  # in the pull request:
  # two sentences about if we're doing anything over the weekend
  # and what our basic idea for monday is going to be

  # maybe talk about buyers logging in w/ Jeremy?

  def display_name
    product.name
  end

  # note that we to talk about this more
  def price # cost / item_cost
    quantity_ordered * product.price
  end
end
