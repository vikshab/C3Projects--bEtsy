class Order < ActiveRecord::Base
  # DB relationships
  has_many :order_items

  # validations helper regex
  # email regex from: http://rails-3-2.railstutorial.org/book/modeling_users#code-validates_format_of_email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_STATUS_REGEX = /(pending)|(paid)|(complete)|(cancelled)/

  # data validations
  validates :status, presence: true, format: { with: VALID_STATUS_REGEX }
  validates :buyer_card_short, numericality: { greater_than: 999, less_than: 10_000 }
  validates :buyer_email, format: { with: VALID_EMAIL_REGEX }
  # validate card expiration is after today / Date.now
  # validate address or name somehow?

  def total_price
    array_of_totals = order_items.map { |item| item.quantity_ordered * item.product.price }
    total = array_of_totals.reduce(0) { |sum, current_total| sum += current_total }
  end
end
