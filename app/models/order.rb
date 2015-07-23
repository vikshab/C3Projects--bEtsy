class Order < ActiveRecord::Base
  # ASSOCIATIONS --------------------------------------------------------
  has_many :order_items
  has_one :buyer
  before_create :set_order_status
  before_save :update_subtotal

  def subtotal
    order_items.collect { |oi| oi.valid? ? (oi.quantity * oi.unit_price) : 0 }.sum
  end

private

    def set_order_status
      self.status = "pending"
    end

    def update_subtotal
      self[:subtotal] = subtotal
    end

end
