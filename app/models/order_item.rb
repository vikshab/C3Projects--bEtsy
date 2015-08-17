class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :order_id, presence: true
  validates :product_id, presence: true
  before_create :set_status
  before_save :finalize

  def unit_price
    # this is a public class method -checks for new or destroyed
    if persisted?
      self[:unit_price]
    else
      product.price
    end
  end

  def total_price
    unit_price * quantity
  end

  def complete_ship
  self.status = "complete"
  end

  private

  def set_status
    self.status = "pending"
  end

  def finalize
    self[:unit_price] = unit_price
    self[:total_price] = quantity * self[:unit_price]
  end
end
