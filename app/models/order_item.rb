class OrderItem < ActiveRecord::Base
  before_save :product_has_stock?

  # DB relationships
  belongs_to :order
  belongs_to :product
  has_one :seller, through: :product


  # data validations
  validates :product_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :order_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :quantity_ordered, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :order_item_is_unique? # OPTIMIZE: I think this makes the above before_create obsolete?!


  def more!
    reload # removing this line == DANGER WILL ROBINSON
    # if the OrderItem isn't reloaded, ln30 will resolve based on a cached operation
    # in other words, if line 30 has recently been evaluated for this OrderItem,
    # then __it will not be evaluated__ and the cached value (true) will be used
    # instead. by reloading, we force a new SQL query to be run to check anew
    # whether product_has_stock?

    if product_has_stock?
      increment!(:quantity_ordered, 1)
    end
  end

  def less!
    if quantity_ordered > 1
      update_column(:quantity_ordered, quantity_ordered - 1)
    else
      errors.add(:quantity_ordered, "You must remove this from your cart if you want to reduce its quantity any further.")
    end
  end

  def total_item_price
    quantity_ordered * product.price
  end

  def adjust_if_product_stock_changed!
    max_quantity = product.stock
    return if quantity_ordered <= max_quantity
    update_column(:quantity_ordered, max_quantity)
  end

  def remove_product_stock!(how_much)
    product.remove_stock(how_much)
  end

  def product_has_stock? # OPTIMIZE is this the best way to do this?
    if product.stock?
      return true
    else
      errors.add(:quantity_ordered, "Product must have available stock.")
      return false
    end
  end

  def order_item_is_unique? # TODO: anw, fix failing spec after merge. Also, write specs for this!
    #FIXME: this method should only fire when a record is being CREATED
    if OrderItem.where(product_id: product_id, order_id: order_id).count > 0
      errors.add(:product_not_unique, "That product is already in your cart.")
    end
  end
end
