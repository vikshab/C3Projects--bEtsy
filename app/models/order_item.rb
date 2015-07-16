class OrderItem < ActiveRecord::Base
  # DB relationships
  belongs_to :product
  belongs_to :order

  # data validations
  # validates :product_id, presence: true, numericality: { ??? }
  # validates :order_id, presence: true, numericality: { ??? }
  validates :quantity_ordered, presence: true, numericality: true

  def increase # quantity
    quantity_ordered.increment!
  end

  def decrease # quantity
    # !Q should this flash.now an error instead of destroying the order item?
    # or should / can we add some logic to prompt upon decreasing from one to zero & then destroy?
    quantity_ordered == 1 ? destroy : quantity_ordered.decrement!
  end

  def remove_prompt_text
    "Are you sure you want to remove this item (#{ quantity_ordered } #{ display_name }) from your cart?"
  end

  def display_name
    name = product.name
    quantity_ordered == 1 ? name.singularize : name.pluralize
  end

  def cost
    quantity_ordered * product.price
  end
end
