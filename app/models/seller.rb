class Seller < ActiveRecord::Base
  has_secure_password
  has_many :products
  has_many :order_items, through: :products
  has_many :orders, -> { uniq }, through: :order_items

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def total_revenue
    self.order_items.map(&:total_item_price).sum
  end

  def revenue(status)
    self.order_items.where(status: status).map(&:total_item_price).sum
  end

  def count_orders(status) # this is actually counting order items
    self.order_items.where(status: status).count
  end

  def fetch_orders(status=false)
    if status
      self.orders.where(status: status)
    else
      self.orders
    end
  end
end
