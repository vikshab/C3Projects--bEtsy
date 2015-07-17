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

  def remove_prompt_text
    "Are you sure you want to remove this item (#{ quantity_ordered } #{ display_name }) from your cart?"
  end

  def display_name
    name = product.name.capitalize
    quantity_ordered == 1 ? name.singularize : name.pluralize
  end

  def price
    quantity_ordered * product.price
  end
end
