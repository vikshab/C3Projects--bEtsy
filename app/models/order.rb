class Order < ActiveRecord::Base
  # DB relationships
  has_many :order_items, dependent: :destroy
  # should destroy all of the associated OrderItems if an Order is destroyed.
  # we can use this as part of the cleaning task we set up to kill any pending
  # orders inactive for whatever time we set.
  # (20-30 minutes? a day? anything inactive for over 2hrs, but only run task once a day?)
  has_many :products, through: :order_items


  # validations helper regex
  # email regex from: http://rails-3-2.railstutorial.org/book/modeling_users#code-validates_format_of_email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  # data validations
  validates :status, presence: true, inclusion: { in: %w(pending paid complete canceled),
    message: "%{value} is not a valid status" }

  validates_presence_of :buyer_email, unless: :pending?
  validates_format_of :buyer_email, with: VALID_EMAIL_REGEX, unless: :pending?

  validates_presence_of :buyer_name, unless: :pending?
  validates_presence_of :buyer_address, unless: :pending?
  # TODO: validate address or name somehow?

  validates_presence_of :buyer_card_short, unless: :pending?
  validates_numericality_of :buyer_card_short, only_integer: true, greater_than: 999, less_than: 10_000, unless: :pending?
  # FIXME: these will not handle for cards that end in: 0812, 0002, 0404, etc.

  validates_presence_of :buyer_card_expiration, unless: :pending?
  # TODO: validate card expiration is after today / Date.now


  def order_price
    # TODO: come back and talk about the method names
    # but fwiw Order.price makes sense to me. more detailed explanation in Orderitem model. -J
    array_of_totals = order_items.map { |item| item.item_price }
    total = array_of_totals.reduce(0) { |sum, current_total| sum += current_total }
  end

  def already_has_product?(product)
    products.include? product
  end

  def pending?
    status == "pending"
  end
end
